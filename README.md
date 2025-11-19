Создание рабочей директории и клонирование репозитория
```
wisteria@HOME-PC:~$ cd starter_repo_dev
wisteria@HOME-PC:~/starter_repo_dev$ git clone https://github.com/wisteria2606/Lab1
Cloning into 'Lab1'...
remote: Enumerating objects: 22, done.
remote: Counting objects: 100% (22/22), done.
remote: Compressing objects: 100% (16/16), done.
remote: Total 22 (delta 0), reused 0 (delta 0), pack-reused 0 (from 0)
Receiving objects: 100% (22/22), 4.60 KiB | 523.00 KiB/s, done.
wisteria@HOME-PC:~/starter_repo_dev$ cd Lab1
```
Переход в проект, запуск Docker и тестирование проекта
```
wisteria@HOME-PC:~/starter_repo_dev/Lab1$ cd starter_repo
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ docker compose up -d --build
[+] Running 1/1
 ✔ Container starter_repo-app-1  Started                                                                                                                                            1.4s 
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ docker compose exec app python -m pytest -q
...                                                                                                                                                                               [100%]
3 passed in 0.04s
```
Настройка Git и GPG
```
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ git config --global user.name wisteria2606
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ git config --global user.email nastik.ledy@gmail.com
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ gpg --list-secret-keys --keyid-format=long
/home/wisteria/.gnupg/pubring.kbx
---------------------------------
sec   rsa4096/AA6C4483CB869C77 2025-11-14 [SC]
      4677CD6E4AFA0BB5A533BDF0AA6C4483CB869C77
uid                 [ultimate] Anastasia <nastik.ledy@gmail.com>
ssb   rsa4096/0895E46AC88739DD 2025-11-14 [E]

wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ git config --global user.signingkey 4677CD6E4AFA0BB5A533BDF0AA6C4483CB869C77
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ git config --global commit.gpgsign true
```
Создание новой ветки
```
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ git checkout -b feature/setup
Switched to a new branch 'feature/setup'
```
Проверка синхронизации с origin/main
```
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ git fetch origin && git rebase origin/main
Current branch feature/setup is up to date.
```
Добавление и коммит изменений
```
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ git add .
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ git commit -m "ok"
[feature/setup 03bb708] ok
 5 files changed, 11 insertions(+), 25 deletions(-)
 create mode 100644 starter_repo/app/__pycache__/__init__.cpython-311.pyc
 create mode 100644 starter_repo/app/__pycache__/calc.cpython-311.pyc
 create mode 100644 starter_repo/tests/__pycache__/test_calc.cpython-311-pytest-7.4.4.pyc
 create mode 100644 starter_repo/tests/__pycache__/test_smoke.cpython-311-pytest-7.4.4.pyc
```
Демонстрация работы git bisect
```
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ bash scripts/bisect_demo_init.sh
[feature/setup a3cabd3] [demo] add calc_good.py
 1 file changed, 6 insertions(+)
 create mode 100644 starter_repo/app/calc_good.py
[feature/setup a98125f] [demo] introduce bug
 1 file changed, 2 insertions(+), 4 deletions(-)
[ok] created tag good_baseline and bad HEAD
```
Запуск поиска ошибочного коммита
```
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ cd -
/home/wisteria
wisteria@HOME-PC:~$ cd ~/starter_repo_dev/Lab1
wisteria@HOME-PC:~/starter_repo_dev/Lab1$ git bisect start
status: waiting for both good and bad commits
wisteria@HOME-PC:~/starter_repo_dev/Lab1$ git bisect start
Already on 'feature/setup'
status: waiting for both good and bad commits
wisteria@HOME-PC:~/starter_repo_dev/Lab1$ git bisect bad HEAD
status: waiting for good commit(s), bad commit known
wisteria@HOME-PC:~/starter_repo_dev/Lab1$ git bisect good good_baseline
a98125fa537237813c913e78766eff33cc3049a8 is the first bad commit
commit a98125fa537237813c913e78766eff33cc3049a8
Author: wisteria2606 <nastik.ledy@gmail.com>
Date:   Sat Nov 15 11:20:41 2025 +0600

    [demo] introduce bug

 starter_repo/app/calc.py | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)
 ```
Настройка pre-commit хуков
Установка pre-commit:
```
wisteria@HOME-PC:~/starter_repo_dev/Lab1$ pre-commit install
pre-commit installed at .git/hooks/pre-commit
wisteria@HOME-PC:~/starter_repo_dev/Lab1$ cd starter_repo
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ touch .pre-commit-config.yaml
```
При первом запуске pre-commit без конфигурации возникла ошибка:
```
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ pre-commit run -a
An error has occurred: InvalidConfigError:
==> File starter_repo/.pre-commit-config.yaml
=====> Expected a Config map but got a NoneType
Check the log at /home/wisteria/.cache/pre-commit/pre-commit.log
```
Решение: отредактирован файл .pre-commit-config.yaml с добавлением необходимых хуков (black, flake8):
```
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ vim .pre-commit-config.yaml
```
После конфигурации запущены проверки:
```
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ pre-commit run -a
[INFO] Installing environment for https://github.com/psf/black.
[INFO] Once installed this environment will be reused.
[INFO] This may take a few minutes...
[INFO] Installing environment for https://github.com/pycqa/flake8.
[INFO] Once installed this environment will be reused.
[INFO] This may take a few minutes...
black....................................................................Failed
- hook id: black
- files were modified by this hook

reformatted starter_repo/tests/test_smoke.py
reformatted starter_repo/app/calc.py
reformatted starter_repo/app/calc_buggy.py
reformatted starter_repo/app/calc_good.py
reformatted starter_repo/tests/test_calc.py

All done! ✨ 🍰 ✨
5 files reformatted, 1 file left unchanged.

flake8...................................................................Failed
- hook id: flake8
- exit code: 1

starter_repo/app/__init__.py:1:1: W391 blank line at end of file
starter_repo/app/calc.py:2:80: E501 line too long (80 > 79 characters)
starter_repo/app/calc_buggy.py:2:80: E501 line too long (80 > 79 characters)
```
Black автоматически переформатировал 5 файлов, а flake8 выявил нарушения стиля:
•	Пустая строка в конце файла __init__.py
•	Строки, превышающие лимит 79 символов в calc.py и calc_buggy.py
После исправления всех ошибок успешно выполнен коммит:
```
wisteria@HOME-PC:~/starter_repo_dev/Lab1/starter_repo$ git commit
black....................................................................Passed
flake8...................................................................Passed
```
