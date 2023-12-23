resource "local_file" "ansible_inventory" {
  content = templatefile(
    "${abspath(path.module)}/templates/hosts.tftpl",
    {
      clickhouse = module.clickhouse.external_ip_address
      vector     = module.vector.external_ip_address
      lighthouse = module.lighthouse.external_ip_address
    }
  )
  filename = "${dirname("../playbook/inventory/prod.yml")}/prod.yml"
}

resource "null_resource" "web_hosts_provision" {
  #Ждем создания инстанса
  depends_on = [module.clickhouse, module.vector, module.lighthouse]

  #Добавление ПРИВАТНОГО ssh ключа в ssh-agent
  provisioner "local-exec" {
    command = "cat ~/.ssh/id_ed25519 | ssh-add -"
  }

  #Запуск ansible-playbook
  provisioner "local-exec" {
    command     = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${dirname("../playbook/inventory/prod.yml")}/prod.yml ${dirname("../playbook/site.yml")}/site.yml"
    on_failure  = continue #Продолжить выполнение terraform pipeline в случае ошибок
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
    #срабатывание триггера при изменении переменных
  }
  triggers = {
    always_run        = "${timestamp()}"                                         #всегда т.к. дата и время постоянно изменяются
    playbook_src_hash = file("${dirname("../playbook/site.yml")}/site.yml")      # при изменении содержимого playbook файла
    ssh_public_key    = data.template_file.cloudinit_ansible.vars.ssh_public_key # при изменении переменной

  }

}
