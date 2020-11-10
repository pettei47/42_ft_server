# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    readme.txt                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: teppei <teppei@student.42.fr>              +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/11/09 00:35:41 by teppei            #+#    #+#              #
#    Updated: 2020/11/10 19:44:36 by teppei           ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

reviewの手順

1) docker image を作る (-t はイメージの名前を指定するオプション, ./はdockerfileのパス)
docker image build -t ft_server ./

2) docker container を作る
	(-p [ホストのポート:コンテナの解放するポート], --name [コンテナ名 イメージ名])
docker run -itd -p 8080:80 -p 443:443 --name review ft_server

3) コンテナが起動しているか確認
docker ps 

4) https://localhost:8080
wordpressにアクセスしてユーザー登録
phpmyadminにアクセスしてデータベース確認（ID、パス：user / user ※Dockerfileから確認できる。）
wordpressで投稿を作成するなどしてデータベースに変化があることを確認

https://localhost/wordpress/xxxxx
https://localhost/phpmyadmin/xxxxx
にアクセスしてリダイレクトされることを確認

5) コンテナの中に入る　このステップはしなくてもいい。
docker exec -it review /bin/bash

6) コンテナを停止する
docker stop review

7) コンテナを削除する
docker container rm review 

8) autoindexの設定を、コンテナ起動時に変えられるようにする
	(AUTOINDEX=offという環境変数をコンテナ内に定義)
docker run -itd -p 8080:80 -p 443:443 -e AUTOINDEX=off --name review ft_server

9) https://localhost -> 403 forbidden
   https://localhost/wordpress

10) コンテナを停止する
docker stop review

11) コンテナを削除する
docker container rm review  

12) イメージを削除する ※削除しておかないと容量を圧迫するため。
docker image rm ft_server
