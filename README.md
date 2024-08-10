# Светиков И.А. ДЗ Ansible часть 2

### Задание 1

**Выполните действия, приложите файлы с плейбуками и вывод выполнения.**

Напишите три плейбука. При написании рекомендуем использовать текстовый редактор с подсветкой синтаксиса YAML.

Плейбуки должны: 

1. Скачать какой-либо архив, создать папку для распаковки и распаковать скаченный архив. Например, можете использовать [официальный сайт](https://kafka.apache.org/downloads) и зеркало Apache Kafka. При этом можно скачать как исходный код, так и бинарные файлы, запакованные в архив — в нашем задании не принципиально.
2. Установить пакет tuned из стандартного репозитория вашей ОС. Запустить его, как демон — конфигурационный файл systemd появится автоматически при установке. Добавить tuned в автозагрузку.
3. Изменить приветствие системы (motd) при входе на любое другое. Пожалуйста, в этом задании используйте переменную для задания приветствия. Переменную можно задавать любым удобным способом.

**список хостов**

```
---
all:
  hosts:
    server1:
      ansible_host: 192.168.56.101
    server2:
      ansible_host: 192.168.56.3
```

**переменные для хостов**

```
---
ansible_user: igoryanich
ansible_ssh_private_key_file: /home/igoryanich/.ssh/id_rsa
hello_var: 'printf ""{{ ansible_nodename }}" "{{ ansible_enp0s8.ipv4.address }}" GOODLUCK"'
```

Плейбук 1:
/playbooks/playbook1.yml

```
---
- name: "Download and unarchive"
  hosts: all
  become: yes
  connection: ssh
  
  tasks:
  - name: "download archive from"
    ansible.builtin.get_url:
          url: 'https://downloads.apache.org/kafka/3.8.0/kafka-3.8.0-src.tgz'
          dest: /home/igoryanich/downd.tgz
          mode: 0775
          owner: igoryanich
          group: igoryanich

  - name: "unarchive"
    ansible.builtin.unarchive:
          src: /home/igoryanich/downd.tgz
          dest: /home/igoryanich/
          remote_src: yes
```

Плейбук 2:
/playbooks/playbook2.yml

```
---
- name: "APT and systemctl"
  hosts: all
  become: yes
  connection: ssh
  tasks:
    - name: "download from APT"
      ansible.builtin.apt:
        name: tuned
        state: present

    - name: "launch tuned"
      ansible.builtin.systemd_service:
        name: tuned
        enabled: yes
        state: started
```
Плейбук 3:
/playbooks/playbook3.yml

```
- name: "change MOTD"
  hosts: all
  become: yes
  connection: ssh
  tasks:
    - name: "Insert"
      ansible.builtin.lineinfile:
        dest: /etc/update-motd.d/00-header
        line: "{{ hello_var }}"
        create: yes
```

### Задание 2

**Выполните действия, приложите файлы с модифицированным плейбуком и вывод выполнения.** 

Модифицируйте плейбук из пункта 3, задания 1. В качестве приветствия он должен установить IP-адрес и hostname управляемого хоста, пожелание хорошего дня системному администратору. 

**(смотри /playbooks/playbook3.yml)**


### Задание 3

**Выполните действия, приложите архив с ролью и вывод выполнения.**

Ознакомьтесь со статьёй [«Ansible - это вам не bash»](https://habr.com/ru/post/494738/), сделайте соответствующие выводы и не используйте модули **shell** или **command** при выполнении задания.

Создайте плейбук, который будет включать в себя одну, созданную вами роль. Роль должна:

1. Установить веб-сервер Apache на управляемые хосты.
2. Сконфигурировать файл index.html c выводом характеристик каждого компьютера как веб-страницу по умолчанию для Apache. Необходимо включить CPU, RAM, величину первого HDD, IP-адрес.
Используйте [Ansible facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html) и [jinja2-template](https://linuxways.net/centos/how-to-use-the-jinja2-template-in-ansible/). Необходимо реализовать handler: перезапуск Apache только в случае изменения файла конфигурации Apache.
4. Открыть порт 80, если необходимо, запустить сервер и добавить его в автозагрузку.
5. Сделать проверку доступности веб-сайта (ответ 200, модуль uri).

В качестве решения:
- предоставьте плейбук, использующий роль;
- разместите архив созданной роли у себя на Google диске и приложите ссылку на роль в своём решении;
- предоставьте скриншоты выполнения плейбука;
- предоставьте скриншот браузера, отображающего сконфигурированный index.html в качестве сайта.

  **смотри /playbooks/playbook4.yml**

*выполнение плейбука*
![img1](https://github.com/igoryanich94/netology_ansible_part2/blob/main/playbooks/img/img1.png)  
*проверка доступности*
![img2](https://github.com/igoryanich94/netology_ansible_part2/blob/main/playbooks/img/img2.png)
*отображение информации с первой машины*
![img3](https://github.com/igoryanich94/netology_ansible_part2/blob/main/playbooks/img/img3.png)
*отображение информации со второй машины*
![img4](https://github.com/igoryanich94/netology_ansible_part2/blob/main/playbooks/img/img4.png)

  

