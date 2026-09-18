--
-- PostgreSQL database dump
--

\restrict V6srQCcWYfzYWRbVkaH6NuYl8AMvgVl7C1EqU8C0Hl7f0uxpPmYoSXXcWKM10jD

-- Dumped from database version 17.10 (Debian 17.10-1.pgdg13+1)
-- Dumped by pg_dump version 17.10 (Debian 17.10-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgaudit; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgaudit WITH SCHEMA public;


--
-- Name: EXTENSION pgaudit; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgaudit IS 'provides auditing functionality';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: access_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.access_logs (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    member_id uuid NOT NULL,
    action text NOT NULL,
    logged_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT access_logs_action_check CHECK ((action = ANY (ARRAY['check_in'::text, 'check_out'::text])))
);


ALTER TABLE public.access_logs OWNER TO postgres;

--
-- Name: booking_rooms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.booking_rooms (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    branch_id uuid NOT NULL,
    room_name text NOT NULL,
    capacity integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.booking_rooms OWNER TO postgres;

--
-- Name: bookings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bookings (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    member_id uuid NOT NULL,
    room_id uuid NOT NULL,
    start_time timestamp with time zone NOT NULL,
    end_time timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.bookings OWNER TO postgres;

--
-- Name: branches; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.branches (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    name text NOT NULL,
    city text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.branches OWNER TO postgres;

--
-- Name: members; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.members (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    tenant_id uuid NOT NULL,
    branch_id uuid NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.members OWNER TO postgres;

--
-- Name: tenants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tenants (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL,
    plan text DEFAULT 'free'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.tenants OWNER TO postgres;

--
-- Data for Name: access_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.access_logs (id, tenant_id, member_id, action, logged_at) FROM stdin;
f4901a6e-accc-4bdd-87ed-4a1958fd33b4	11111111-1111-1111-1111-111111111111	b1111111-1111-1111-1111-111111111111	check_in	2026-09-17 10:58:35.723554+00
f2b5f2db-3b7b-4d11-9e32-ad79ecd3d316	22222222-2222-2222-2222-222222222222	b2222222-2222-2222-2222-222222222221	check_in	2026-09-17 10:58:35.723554+00
\.


--
-- Data for Name: booking_rooms; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.booking_rooms (id, tenant_id, branch_id, room_name, capacity, created_at) FROM stdin;
c1111111-1111-1111-1111-111111111111	11111111-1111-1111-1111-111111111111	a1111111-1111-1111-1111-111111111111	Meeting Room A	6	2026-09-17 10:58:35.716984+00
c1111111-1111-1111-1111-111111111112	11111111-1111-1111-1111-111111111111	a1111111-1111-1111-1111-111111111111	Conference Hall	20	2026-09-17 10:58:35.716984+00
c2222222-2222-2222-2222-222222222221	22222222-2222-2222-2222-222222222222	a2222222-2222-2222-2222-222222222222	Huddle Room	4	2026-09-17 10:58:35.716984+00
\.


--
-- Data for Name: bookings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bookings (id, tenant_id, member_id, room_id, start_time, end_time, created_at) FROM stdin;
8160447b-5adb-46e1-9127-9e8688c4db6d	11111111-1111-1111-1111-111111111111	b1111111-1111-1111-1111-111111111111	c1111111-1111-1111-1111-111111111111	2026-09-20 04:30:00+00	2026-09-20 05:30:00+00	2026-09-17 10:58:35.720192+00
e71f530b-4b9d-48c0-a302-ebdfb8affd21	22222222-2222-2222-2222-222222222222	b2222222-2222-2222-2222-222222222221	c2222222-2222-2222-2222-222222222221	2026-09-20 08:30:00+00	2026-09-20 09:30:00+00	2026-09-17 10:58:35.720192+00
\.


--
-- Data for Name: branches; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.branches (id, tenant_id, name, city, created_at) FROM stdin;
a1111111-1111-1111-1111-111111111111	11111111-1111-1111-1111-111111111111	Innov8 Noida Sector 62	Noida	2026-09-17 10:58:35.712277+00
a2222222-2222-2222-2222-222222222222	22222222-2222-2222-2222-222222222222	WorkNest Gurugram	Gurugram	2026-09-17 10:58:35.712277+00
\.


--
-- Data for Name: members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.members (id, tenant_id, branch_id, name, email, created_at) FROM stdin;
b1111111-1111-1111-1111-111111111111	11111111-1111-1111-1111-111111111111	a1111111-1111-1111-1111-111111111111	Rahul Sharma	rahul@innov8demo.com	2026-09-17 10:58:35.715189+00
b1111111-1111-1111-1111-111111111112	11111111-1111-1111-1111-111111111111	a1111111-1111-1111-1111-111111111111	Priya Singh	priya@innov8demo.com	2026-09-17 10:58:35.715189+00
b2222222-2222-2222-2222-222222222221	22222222-2222-2222-2222-222222222222	a2222222-2222-2222-2222-222222222222	Amit Verma	amit@worknestdemo.com	2026-09-17 10:58:35.715189+00
51768a2e-47bb-46e3-b19b-aa9aa08d48cd	11111111-1111-1111-1111-111111111111	a1111111-1111-1111-1111-111111111111	Test User	test@innov8demo.com	2026-09-18 05:50:03.913381+00
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tenants (id, name, plan, created_at) FROM stdin;
11111111-1111-1111-1111-111111111111	Innov8 Hub	pro	2026-09-17 10:58:35.707371+00
22222222-2222-2222-2222-222222222222	WorkNest	free	2026-09-17 10:58:35.707371+00
\.


--
-- Name: access_logs access_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_logs
    ADD CONSTRAINT access_logs_pkey PRIMARY KEY (id);


--
-- Name: booking_rooms booking_rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_pkey PRIMARY KEY (id);


--
-- Name: bookings bookings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_pkey PRIMARY KEY (id);


--
-- Name: branches branches_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT branches_pkey PRIMARY KEY (id);


--
-- Name: members members_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_pkey PRIMARY KEY (id);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: idx_bookings_tenant; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_bookings_tenant ON public.bookings USING btree (tenant_id);


--
-- Name: idx_branches_tenant; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_branches_tenant ON public.branches USING btree (tenant_id);


--
-- Name: idx_logs_tenant; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_logs_tenant ON public.access_logs USING btree (tenant_id);


--
-- Name: idx_members_tenant; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_members_tenant ON public.members USING btree (tenant_id);


--
-- Name: idx_rooms_tenant; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_rooms_tenant ON public.booking_rooms USING btree (tenant_id);


--
-- Name: access_logs access_logs_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_logs
    ADD CONSTRAINT access_logs_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id) ON DELETE CASCADE;


--
-- Name: access_logs access_logs_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.access_logs
    ADD CONSTRAINT access_logs_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: booking_rooms booking_rooms_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: booking_rooms booking_rooms_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.booking_rooms
    ADD CONSTRAINT booking_rooms_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: bookings bookings_member_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_member_id_fkey FOREIGN KEY (member_id) REFERENCES public.members(id) ON DELETE CASCADE;


--
-- Name: bookings bookings_room_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_room_id_fkey FOREIGN KEY (room_id) REFERENCES public.booking_rooms(id) ON DELETE CASCADE;


--
-- Name: bookings bookings_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bookings
    ADD CONSTRAINT bookings_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: branches branches_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT branches_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: members members_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id) ON DELETE CASCADE;


--
-- Name: members members_tenant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.members
    ADD CONSTRAINT members_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id) ON DELETE CASCADE;


--
-- Name: access_logs; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.access_logs ENABLE ROW LEVEL SECURITY;

--
-- Name: booking_rooms; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.booking_rooms ENABLE ROW LEVEL SECURITY;

--
-- Name: bookings; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.bookings ENABLE ROW LEVEL SECURITY;

--
-- Name: branches; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.branches ENABLE ROW LEVEL SECURITY;

--
-- Name: members; Type: ROW SECURITY; Schema: public; Owner: postgres
--

ALTER TABLE public.members ENABLE ROW LEVEL SECURITY;

--
-- Name: bookings tenant_isolation_bookings; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tenant_isolation_bookings ON public.bookings USING ((tenant_id = (current_setting('app.current_tenant'::text))::uuid));


--
-- Name: branches tenant_isolation_branches; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tenant_isolation_branches ON public.branches USING ((tenant_id = (current_setting('app.current_tenant'::text))::uuid));


--
-- Name: access_logs tenant_isolation_logs; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tenant_isolation_logs ON public.access_logs USING ((tenant_id = (current_setting('app.current_tenant'::text))::uuid));


--
-- Name: members tenant_isolation_members; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tenant_isolation_members ON public.members USING ((tenant_id = (current_setting('app.current_tenant'::text))::uuid));


--
-- Name: booking_rooms tenant_isolation_rooms; Type: POLICY; Schema: public; Owner: postgres
--

CREATE POLICY tenant_isolation_rooms ON public.booking_rooms USING ((tenant_id = (current_setting('app.current_tenant'::text))::uuid));


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO app_user;


--
-- Name: TABLE access_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.access_logs TO app_user;


--
-- Name: TABLE booking_rooms; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.booking_rooms TO app_user;


--
-- Name: TABLE bookings; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.bookings TO app_user;


--
-- Name: TABLE branches; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.branches TO app_user;


--
-- Name: TABLE members; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.members TO app_user;


--
-- Name: TABLE tenants; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.tenants TO app_user;


--
-- PostgreSQL database dump complete
--

\unrestrict V6srQCcWYfzYWRbVkaH6NuYl8AMvgVl7C1EqU8C0Hl7f0uxpPmYoSXXcWKM10jD

