resource "local_file" "ansible_inventory" {
  content = templatefile(
    "${abspath(path.module)}/templates/hosts.tftpl",
    {
      clickhouse = module.clickhouse.external_ip_address
      vector     = module.vector.external_ip_address
      lighthouse = module.lighthouse.external_ip_address
    }
  )
  filename = "${dirname("../playbook/inventory/")}/prod.yml"
}

resource "null_resource" "web_hosts_provision" {
  #Ждем создания инстанса
  depends_on = [module.clickhouse, module.vector, module.lighthouse]

  #Добавление ПРИВАТНОГО ssh ключа в ssh-agent
  provisioner "local-exec" {
    command = "eval `ssh-agent -s` && cat ~/.ssh/id_ed25519 | ssh-add -"
  }

  # Добавление ролей
  provisioner "local-exec" {
    command    = "ansible-galaxy install -r ${dirname("../playbook/")}/requirements.yml -p ${dirname("../playbook/roles/")} --force"
    on_failure = continue #Продолжить выполнение terraform pipeline в случае ошибок

  }

  # Запуск ansible-playbook
  provisioner "local-exec" {
    command     = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${dirname("../playbook/inventory/")}/prod.yml ${dirname("../playbook/")}/site.yml"
    on_failure  = continue
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
    #срабатывание триггера при изменении переменных
  }
  triggers = {
    always_run        = "${timestamp()}"                            #всегда т.к. дата и время постоянно изменяются
    playbook_src_hash = file("${dirname("../playbook/")}/site.yml") # при изменении содержимого playbook файла
    ssh_public_key    = file("~/.ssh/id_ed25519.pub")               # при изменении переменной

  }

}
