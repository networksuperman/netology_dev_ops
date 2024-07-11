resource "yandex_mdb_mysql_cluster" "cluster-mysql" {
  name        = "cluster-mysql"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.devops_net.id
  version     = "8.0"
  backup_window_start {
    hours   = 23
    minutes = 59
  }

  resources {
    resource_preset_id = "b1.medium"
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  mysql_config = {
    sql_mode                      = "ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION"
    max_connections               = 100
    default_authentication_plugin = "MYSQL_NATIVE_PASSWORD"
    innodb_print_all_deadlocks    = true

  }

  host {
    zone      = var.a_zone
    subnet_id = yandex_vpc_subnet.private-subnet-a.id
  }

  host {
    zone      = var.b_zone
    subnet_id = yandex_vpc_subnet.private-subnet-b.id
  }

  host {
    zone      = var.c_zone
    subnet_id = yandex_vpc_subnet.private-subnet-c.id
  }

  deletion_protection = true

  maintenance_window {
    type = "ANYTIME"
  }
}

resource "yandex_mdb_mysql_database" "mysql_database" {
  cluster_id = yandex_mdb_mysql_cluster.cluster-mysql.id
  name       = "netology_db"
}

resource "yandex_mdb_mysql_user" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.cluster-mysql.id
  name       = "netology_db"
  password   = "netology_db"

  permission {
    database_name = yandex_mdb_mysql_database.mysql_database.name
    roles         = ["ALL"]
  }
  connection_limits {
    max_questions_per_hour   = 1000
    max_updates_per_hour     = 2000
    max_connections_per_hour = 3000
    max_user_connections     = 4000
  }

  global_permissions = ["PROCESS"]

  authentication_plugin = "MYSQL_NATIVE_PASSWORD"
}
