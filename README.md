* 설치 순서
```bash
  # 컨테이너 상태 확인
  docker ps -a

  # 컨테이너 이미지 확인
  docker images -a

  # 실행중지된 컨테이너 삭제
  docker container prune -f

  # 도커이미지 삭제
  docker image prune -af

  # 도커이미지 생성(캐쉬무시)
  docker-compose build --no-cache

  # 도커컴포즈를 통해서 컨테이너 실행
  docker-compose up -d
```
