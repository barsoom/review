--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: authors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE authors (
    id integer NOT NULL,
    name character varying(255),
    email character varying(255),
    username character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: authors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE authors_id_seq OWNED BY authors.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE comments (
    id integer NOT NULL,
    payload text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    github_id integer NOT NULL,
    commit_sha character varying(255) NOT NULL,
    author_id integer NOT NULL,
    resolved_at timestamp without time zone,
    resolved_by_author_id integer,
    json_payload text
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: commits; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE commits (
    id integer NOT NULL,
    sha character varying(255) NOT NULL,
    payload text NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    reviewed_at timestamp without time zone,
    author_id integer NOT NULL,
    reviewed_by_author_id integer,
    review_started_at timestamp without time zone,
    review_started_by_author_id integer,
    json_payload text NOT NULL
);


--
-- Name: commits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE commits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: commits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE commits_id_seq OWNED BY commits.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY authors ALTER COLUMN id SET DEFAULT nextval('authors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY commits ALTER COLUMN id SET DEFAULT nextval('commits_id_seq'::regclass);


--
-- Name: authors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY authors
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- Name: comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: commits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY commits
    ADD CONSTRAINT commits_pkey PRIMARY KEY (id);


--
-- Name: index_comments_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_author_id ON comments USING btree (author_id);


--
-- Name: index_comments_on_commit_sha; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_commit_sha ON comments USING btree (commit_sha);


--
-- Name: index_comments_on_github_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_comments_on_github_id ON comments USING btree (github_id);


--
-- Name: index_comments_on_resolved_by_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_comments_on_resolved_by_author_id ON comments USING btree (resolved_by_author_id);


--
-- Name: index_commits_on_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commits_on_author_id ON commits USING btree (author_id);


--
-- Name: index_commits_on_review_started_by_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commits_on_review_started_by_author_id ON commits USING btree (review_started_by_author_id);


--
-- Name: index_commits_on_reviewed_by_author_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commits_on_reviewed_by_author_id ON commits USING btree (reviewed_by_author_id);


--
-- Name: index_commits_on_sha; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_commits_on_sha ON commits USING btree (sha);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO "schema_migrations" (version) VALUES (20140612192154), (20140612195411), (20140612203902), (20140613132426), (20140614203135), (20140615173312), (20140617173806), (20140617181453), (20140617211211), (20140622184544), (20140701184309), (20160203135406), (20160203140631), (20160203143316), (20160908125356);

