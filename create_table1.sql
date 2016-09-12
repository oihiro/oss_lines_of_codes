create table t_oss_lines (
  id serial primary key,
  oss_name varchar(256) not null,
  version varchar(128),
  download_URL text,
  created_date date,
  lines_of_codes int not null,
  unique(oss_name, version, download_URL)
);
