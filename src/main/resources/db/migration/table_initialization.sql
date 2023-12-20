create schema "advisory";
set schema 'advisory';

create type phone_numbers_type as enum ('home', 'work', 'mobile');
create type advisor_role as enum ('associate', 'partner', 'senior');
create type application_status as enum ('new', 'assigned', 'on_hold', 'approved', 'canceled', 'declined');
create type user_type as enum ('advisor', 'applicant');


create table if not exists users
(
    id        bigserial,
    email     text not null,
    user_name text not null,
    constraint users_pk primary key (id),
    constraint email_uq unique (email),
    constraint user_name_uq unique (user_name)
);

create table if not exists advisors
(
    id   bigserial,
    role advisory.advisor_role not null,
    constraint advisors_pk primary key (id)
);

create table if not exists applicants
(
    id                     bigserial,
    first_name             text    not null,
    last_name              text    not null,
    social_security_number integer not null
);

create table if not exists addresses
(
    id     bigserial,
    city   text    not null,
    street text    not null,
    number integer not null,
    zip    integer not null,
    apt    integer not null,
    constraint addresses_pk primary key (id)
);

create table if not exists phone_numbers
(
    id           bigserial,
    phone_number text                        not null,
    type         advisory.phone_numbers_type not null,
    applicant_id bigserial,
    constraint phone_numbers_pk primary key (id),
    constraint phone_numbers_applicant_fk foreign key (applicant_id) references applicants
);

create table if not exists applications
(
    id           bigserial,
    amount       money                       not null,
    status       advisory.application_status not null,
    created_at   timestamp                   not null default now(),
    assigned_at  timestamp                   not null,
    advisor_id   bigserial,
    applicant_id bigserial,
    constraint applicants_pk primary key (id),
    constraint applicants_advisors_fk foreign key (advisor_id) references advisors,
    constraint applicants_applicants_fk foreign key (applicant_id) references applicants
);

