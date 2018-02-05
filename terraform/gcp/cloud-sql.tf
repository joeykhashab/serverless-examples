resource "google_sql_database_instance" "master" {
  database_version = "MYSQL_5_7"
  region = "us-central1"
  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_user" "users" {
  name     = "admin"
  instance = "${google_sql_database_instance.master.name}"
  host     = "*"
  password = "changeme"
}
