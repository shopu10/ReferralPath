from datetime import date
import mysql.connector
import pandas as pd
import plotly.express as px
import streamlit as st

st.set_page_config(page_title="ReferralPath", page_icon="🏥", layout="wide")

st.markdown("""
<style>
.stApp{background:#07111f}.block-container{max-width:1400px;padding-top:2rem}
[data-testid="stSidebar"]{background:#091525;border-right:1px solid #19314e}
.hero{padding:28px;border:1px solid #1b3656;border-radius:22px;background:linear-gradient(135deg,#0d1c30,#102b46);margin-bottom:20px}
.hero h1{margin:0;font-size:42px}.hero p{color:#9eb2c9;margin:8px 0 0;font-size:16px}
div[data-testid="stMetric"]{background:#0d1b2e;border:1px solid #1b3656;padding:14px;border-radius:14px}
</style>
""", unsafe_allow_html=True)

st.session_state.setdefault("host", "127.0.0.1")
st.session_state.setdefault("port", 3306)
st.session_state.setdefault("user", "root")
st.session_state.setdefault("db", "referralpath")
st.session_state.setdefault("password", "")
st.session_state.setdefault("connected", False)


def get_conn():
    return mysql.connector.connect(
        host=st.session_state.host,
        port=int(st.session_state.port),
        user=st.session_state.user,
        password=st.session_state.password,
        database=st.session_state.db,
        autocommit=False,
    )


def query(sql, params=()):
    conn = cur = None
    try:
        conn = get_conn()
        cur = conn.cursor(dictionary=True)
        cur.execute(sql, tuple(params))
        return pd.DataFrame(cur.fetchall())
    finally:
        if cur: cur.close()
        if conn: conn.close()


def call_proc(name, params=()):
    conn = cur = None
    out = []
    p = tuple(params)
    try:
        conn = get_conn()
        cur = conn.cursor(dictionary=True)
        cur.execute(f"CALL {name}({', '.join(['%s'] * len(p))})", p)
        while True:
            try:
                out.append(pd.DataFrame(cur.fetchall()))
            except Exception:
                out.append(pd.DataFrame())
            if not cur.nextset():
                break
        conn.commit()
        return out
    except Exception:
        if conn: conn.rollback()
        raise
    finally:
        if cur: cur.close()
        if conn: conn.close()


def connect_db():
    conn = cur = None
    try:
        conn = get_conn(); cur = conn.cursor()
        cur.execute("SELECT DATABASE()")
        db = cur.fetchone()[0]
        return True, db
    except Exception as exc:
        return False, str(exc)
    finally:
        if cur: cur.close()
        if conn: conn.close()


with st.sidebar:
    st.markdown("## 🏥 ReferralPath")
    st.caption("Government hospital referral + appointment system")
    st.markdown("### MySQL connection")
    st.session_state.host = st.text_input("Host", st.session_state.host)
    st.session_state.port = st.number_input("Port", 1, 65535, int(st.session_state.port))
    st.session_state.user = st.text_input("User", st.session_state.user)
    st.session_state.db = st.text_input("Database", st.session_state.db)
    st.session_state.password = st.text_input("MySQL password", type="password")
    if st.button("Connect", type="primary", use_container_width=True):
        ok, info = connect_db()
        st.session_state.connected = ok
        if ok: st.success(f"Connected to {info}")
        else: st.error(info)
    st.markdown("---")
    page = st.radio("Navigation", ["Overview","Patient","Appointments","Referrals","Queue","Attendance","Admin"])

if not st.session_state.connected:
    st.markdown('<div class="hero"><h1>ReferralPath</h1><p>Connect this dashboard to your local MySQL database <b>referralpath</b>.</p></div>', unsafe_allow_html=True)
    st.info("No .env file is needed. Enter the MySQL password in the sidebar and click Connect.")
    st.stop()


def patients():
    return query("SELECT patient_id, full_name, phone FROM patient ORDER BY full_name")


def specialties():
    return query("SELECT specialty_id, name FROM specialty ORDER BY name")


def facilities():
    return query("SELECT facility_id, name, facility_level FROM health_facility WHERE is_active=TRUE ORDER BY name")


def departments():
    return query("SELECT department_id, name, facility_id FROM department WHERE is_active=TRUE ORDER BY name")


if page == "Overview":
    st.markdown('<div class="hero"><h1>ReferralPath</h1><p>Live availability, capacity-aware appointments, automated referral routing and queue operations.</p></div>', unsafe_allow_html=True)
    a = query("SELECT * FROM v_admin_dashboard ORDER BY facility_level, facility_id")
    q = query("SELECT * FROM v_today_queue")
    ap = query("SELECT appointment_status, COUNT(*) total FROM v_appointment_dashboard GROUP BY appointment_status")
    rr = query("SELECT status, COUNT(*) total FROM referral_request GROUP BY status")
    c1,c2,c3,c4 = st.columns(4)
    c1.metric("Facilities", len(a))
    c2.metric("Departments", int(a.total_departments.sum()) if not a.empty else 0)
    c3.metric("Available doctors", int(a.available_doctors.sum()) if not a.empty else 0)
    c4.metric("Today's queue", len(q))
    l,r = st.columns(2)
    with l:
        st.subheader("Appointment status")
        if not ap.empty:
            f=px.bar(ap,x="appointment_status",y="total",text="total"); f.update_layout(template="plotly_dark",height=300,margin=dict(l=10,r=10,t=20,b=10)); st.plotly_chart(f,use_container_width=True)
    with r:
        st.subheader("Referral status")
        if not rr.empty:
            f=px.pie(rr,names="status",values="total",hole=.55); f.update_layout(template="plotly_dark",height=300,margin=dict(l=10,r=10,t=20,b=10)); st.plotly_chart(f,use_container_width=True)
    st.subheader("Facility operations")
    cols=["facility_name","facility_level","total_departments","active_departments","no_doctor_departments","available_doctors","total_remaining_capacity","attendance_freshness"]
    st.dataframe(a[cols],use_container_width=True,hide_index=True)

elif page == "Patient":
    st.title("Patient Dashboard")
    p=patients()
    if p.empty: st.warning("No patients found."); st.stop()
    pm={f"{x.full_name} — #{int(x.patient_id)}":int(x.patient_id) for x in p.itertuples()}
    pid=pm[st.selectbox("Patient",list(pm))]
    d=query("SELECT * FROM v_patient_dashboard WHERE patient_id=%s ORDER BY appointment_date DESC, appointment_id DESC",(pid,))
    h=query("SELECT * FROM v_patient_referral_history WHERE patient_id=%s ORDER BY requested_at DESC",(pid,))
    st.subheader("Appointments & queue")
    cols=[c for c in ["appointment_date","specialty","facility_name","doctor_name","appointment_status","queue_number","queue_status"] if c in d.columns]
    st.dataframe(d[cols],use_container_width=True,hide_index=True)
    st.subheader("Referral history")
    cols=[c for c in ["specialty","origin_facility","destination_facility","status","reason","requested_at"] if c in h.columns]
    st.dataframe(h[cols],use_container_width=True,hide_index=True)

elif page == "Appointments":
    st.title("Appointment Management")
    p, dep = patients(), departments()
    if p.empty or dep.empty: st.warning("Missing patient or department data."); st.stop()
    pm={f"{x.full_name} — #{int(x.patient_id)}":int(x.patient_id) for x in p.itertuples()}
    dm={f"{x.name} — Dept #{int(x.department_id)}":int(x.department_id) for x in dep.itertuples()}
    pl=st.selectbox("Patient",list(pm)); dl=st.selectbox("Department",list(dm)); did=dm[dl]
    appt_date=st.date_input("Appointment date",date.today())
    slots=query("SELECT slot_id,slot_name,start_time,end_time FROM department_slot WHERE department_id=%s AND is_active=TRUE ORDER BY start_time",(did,))
    if slots.empty:
        st.error("No active slots for this department."); slot_id=None
    else:
        sm={f"{x.slot_name} ({x.start_time}–{x.end_time}) — #{int(x.slot_id)}":int(x.slot_id) for x in slots.itertuples()}
        slot_id=sm[st.selectbox("Time slot",list(sm))]
    doctors=query("""SELECT DISTINCT d.doctor_id,d.full_name,va.attendance_status
        FROM doctor d JOIN doctor_assignment da ON da.doctor_id=d.doctor_id
        LEFT JOIN v_doctor_attendance va ON va.doctor_id=d.doctor_id
        WHERE d.status='ACTIVE' AND da.department_id=%s AND da.start_date<=%s
          AND (da.end_date IS NULL OR da.end_date>=%s) ORDER BY d.full_name""",(did,appt_date,appt_date))
    if appt_date==date.today(): doctors=doctors[doctors.attendance_status.fillna("")=="PRESENT"]
    dchoices=["Automatic doctor / none"]+[f"{x.full_name} — #{int(x.doctor_id)}" for x in doctors.itertuples()]
    doctor_map={"Automatic doctor / none":None}; doctor_map.update({f"{x.full_name} — #{int(x.doctor_id)}":int(x.doctor_id) for x in doctors.itertuples()})
    doctor=st.selectbox("Doctor",dchoices)
    reason=st.text_area("Reason")
    if appt_date==date.today():
        live=query("SELECT daily_limit,used_capacity,remaining_capacity,booked_appointments,available_doctors,department_status FROM v_department_live_status WHERE department_id=%s",(did,))
        if not live.empty:
            m1,m2,m3=st.columns(3); m1.metric("Daily limit",int(live.iloc[0].daily_limit)); m2.metric("Booked",int(live.iloc[0].booked_appointments)); m3.metric("Capacity left",int(live.iloc[0].remaining_capacity))
    if st.button("Book Appointment",type="primary",use_container_width=True):
        if slot_id is None: st.error("Select a valid slot.")
        else:
            try:
                rs=call_proc("sp_book_appointment",(pm[pl],did,slot_id,doctor_map[doctor],appt_date,reason)); st.success("Appointment booked successfully.")
                for df in rs:
                    if not df.empty: st.dataframe(df,use_container_width=True,hide_index=True)
            except Exception as e: st.error(str(e))
    st.subheader("Recent appointments")
    st.dataframe(query("SELECT appointment_id,appointment_date,patient_name,department_name,facility_name,slot_name,doctor_name,appointment_status,queue_number,queue_status FROM v_appointment_dashboard ORDER BY appointment_date DESC,appointment_id DESC LIMIT 25"),use_container_width=True,hide_index=True)

elif page == "Referrals":
    st.title("Smart Referral Engine")
    p,s,f=patients(),specialties(),facilities()
    if p.empty or s.empty or f.empty: st.warning("Missing reference data."); st.stop()
    pm={f"{x.full_name} — #{int(x.patient_id)}":int(x.patient_id) for x in p.itertuples()}
    sm={f"{x.name} — #{int(x.specialty_id)}":int(x.specialty_id) for x in s.itertuples()}
    fm={f"{x.name} — #{int(x.facility_id)}":int(x.facility_id) for x in f.itertuples()}
    pl=st.selectbox("Patient",list(pm)); sl=st.selectbox("Requested specialty",list(sm))
    if st.button("Check live referral options",type="primary"):
        try: st.session_state.opts=call_proc("sp_find_referral_options",(pm[pl],sm[sl]))[-1]
        except Exception as e: st.error(str(e))
    opts=st.session_state.get("opts",pd.DataFrame())
    if not opts.empty:
        cols=[c for c in ["facility_name","facility_level","available_doctors","remaining_capacity","attendance_freshness","attendance_consistency_pct","facility_referral_status","hierarchy_priority"] if c in opts.columns]
        st.dataframe(opts[cols],use_container_width=True,hide_index=True)
        origin=fm[st.selectbox("Origin facility",list(fm))]
        reason=st.text_area("Referral reason","Specialist service unavailable at origin facility")
        if st.button("Run Automatic Routing",type="primary"):
            try:
                rs=call_proc("sp_route_referral",(pm[pl],sm[sl],origin,reason)); st.success("Referral routing completed.")
                for df in rs:
                    if not df.empty: st.dataframe(df,use_container_width=True,hide_index=True)
            except Exception as e: st.error(str(e))
    st.subheader("Referral history")
    st.dataframe(query("SELECT referral_id,patient_id,patient_name,specialty,origin_facility,destination_facility,status,reason,requested_at FROM v_patient_referral_history ORDER BY requested_at DESC LIMIT 25"),use_container_width=True,hide_index=True)

elif page == "Queue":
    st.title("Live Queue Control")
    dep=departments(); dm={f"{x.name} — Dept #{int(x.department_id)}":int(x.department_id) for x in dep.itertuples()}
    did=dm[st.selectbox("Department",list(dm))]
    q=query("SELECT queue_id,queue_number,patient_name,doctor_name,appointment_status,queue_status,called_at,completed_at FROM v_today_queue WHERE department_id=%s ORDER BY queue_number",(did,))
    a,b,c=st.columns(3); a.metric("Waiting",int((q.queue_status=="WAITING").sum()) if not q.empty else 0); b.metric("Called",int((q.queue_status=="CALLED").sum()) if not q.empty else 0); c.metric("In service",int((q.queue_status=="IN_SERVICE").sum()) if not q.empty else 0)
    if st.button("Call Next Patient",type="primary"):
        try: call_proc("sp_call_next_patient",(did,date.today())); st.success("Next patient called."); st.rerun()
        except Exception as e: st.error(str(e))
    st.dataframe(q,use_container_width=True,hide_index=True)
    active=q[q.queue_status.isin(["CALLED","IN_SERVICE"])] if not q.empty else q
    if not active.empty:
        qm={f"#{int(x.queue_number)} — {x.patient_name} — {x.queue_status}":int(x.queue_id) for x in active.itertuples()}; qid=qm[st.selectbox("Active queue entry",list(qm))]; status=active.loc[active.queue_id==qid,"queue_status"].iloc[0]
        if status=="CALLED" and st.button("Start Service"):
            try: call_proc("sp_start_queue_service",(qid,)); st.success("Service started."); st.rerun()
            except Exception as e: st.error(str(e))
        if status=="IN_SERVICE" and st.button("Complete Visit"):
            try: call_proc("sp_complete_queue_visit",(qid,)); st.success("Visit completed."); st.rerun()
            except Exception as e: st.error(str(e))

elif page == "Attendance":
    st.title("Live Doctor Attendance")
    c=query("SELECT dc.credential_id,d.full_name,hf.name facility_name FROM doctor_credential dc JOIN doctor d ON d.doctor_id=dc.doctor_id JOIN health_facility hf ON hf.facility_id=dc.facility_id ORDER BY d.full_name")
    s=query("SELECT source_id,facility_id,source_name FROM attendance_source WHERE is_active=TRUE ORDER BY facility_id,source_id")
    if not c.empty and not s.empty:
        cm={f"{x.full_name} — {x.facility_name} — Credential #{int(x.credential_id)}":int(x.credential_id) for x in c.itertuples()}
        sm={f"{x.source_name} — Facility #{int(x.facility_id)}":int(x.source_id) for x in s.itertuples()}
        cl=st.selectbox("Doctor credential",list(cm)); sl=st.selectbox("Attendance source",list(sm)); ev=st.selectbox("Event",["PUNCH_IN","PUNCH_OUT"])
        if st.button("Record Attendance",type="primary"):
            try: call_proc("sp_record_attendance_punch",(cm[cl],sm[sl],ev)); st.success("Attendance recorded."); st.rerun()
            except Exception as e: st.error(str(e))
    st.dataframe(query("SELECT doctor_id,full_name,facility_name,last_event_type,attendance_status,attendance_freshness FROM v_doctor_attendance ORDER BY doctor_id"),use_container_width=True,hide_index=True)

elif page == "Admin":
    st.title("Admin Facility Dashboard")
    a=query("SELECT * FROM v_admin_dashboard ORDER BY facility_level,facility_id"); d=query("SELECT * FROM v_facility_dashboard ORDER BY district_id,facility_level,facility_id")
    if a.empty: st.warning("No admin data."); st.stop()
    c1,c2,c3,c4=st.columns(4); c1.metric("Facilities",len(a)); c2.metric("Departments",int(a.total_departments.sum())); c3.metric("Available doctors",int(a.available_doctors.sum())); c4.metric("Remaining capacity",int(a.total_remaining_capacity.sum()))
    x=a[["facility_name","available_doctors","total_remaining_capacity"]].melt(id_vars=["facility_name"],var_name="metric",value_name="value"); f=px.bar(x,x="facility_name",y="value",color="metric",barmode="group"); f.update_layout(template="plotly_dark",height=420,margin=dict(l=10,r=10,t=20,b=120),xaxis_tickangle=-35); st.plotly_chart(f,use_container_width=True)
    cols=["facility_name","facility_level","total_departments","active_departments","no_doctor_departments","total_booked_appointments","total_remaining_capacity","available_doctors","attendance_freshness"]
    st.dataframe(a[cols],use_container_width=True,hide_index=True)
    st.subheader("Department-level live status")
    cols=[c for c in ["facility_name","facility_level","specialty_name","available_doctors","remaining_capacity","booked_appointments","facility_referral_status","attendance_freshness","attendance_consistency_pct"] if c in d.columns]
    st.dataframe(d[cols],use_container_width=True,hide_index=True)
