# ft_server

This is one of 42 project's output.

Dockerfile sets up a web server with Nginx, in only one docker container.  
The container OS must be debian buster.

The server is able to run several services at the same time.  
The services are a WordPress website, phpMyAdmin and MySQL.  


## How to review

1) docker image を作る  
	(-t はイメージの名前を指定するオプション, ./はdockerfileのパス)
	```
	docker image build -t ft_server ./
	```
2) docker container を作る  
	(-p [ホストのポート:コンテナの解放するポート], --name [コンテナ名 イメージ名])
	```
	docker run -itd -p 8080:80 -p 443:443 --name review ft_server
	```

3) コンテナが起動しているか確認
	```
	docker ps 
	```

4) Access : https://localhost:8080  
	wordpressにアクセスしてユーザー登録  
	phpmyadminにアクセスしてデータベース確認  
	（ID、パス：user / user ※Dockerfileから確認できる。）  
	wordpressで投稿を作成するなどしてデータベースに変化があることを確認  

	https://localhost/wordpress/xxxxx  
	https://localhost/phpmyadmin/xxxxx  
	にアクセスしてリダイレクトされることを確認

5) コンテナの中に入る　※スキップしてもOK
	```
	docker exec -it review /bin/bash
	```
6) コンテナを停止する
	```
	docker stop review
	```

7) コンテナを削除する
	```
	docker container rm review 
	```

8) autoindexの設定を、コンテナ起動時に変えられるようにする
	(AUTOINDEX=offという環境変数をコンテナ内に定義)
	```
	docker run -itd -p 8080:80 -p 443:443 -e AUTOINDEX=off --name review ft_server
	```
	https://localhost -> 403 forbidden  
	https://localhost/wordpress

9)  コンテナを停止する
	```
	docker stop review
	```

10) コンテナを削除する
	```
	docker container rm review  
	```
11) イメージ削除する
	```
	docker image rm ft_server
	```