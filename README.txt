퓨쳐시스템 서버용 ISO 만들기

					작업자 : 채문창 <mcchae@future.co.kr>

1. 기본 Base 시스템
- Ubuntu 16.04 LTS Server
  - Ubuntu 16.04 Base
- Ubuntu 14.04.2 LTS Server
  - Ubuntu 14.04 Base
  - 2019년4월까지 지원됨

2. build

2.1 우분투 16.04로 설치할 경우
- ubuntu-16.04-server-amd64.iso 이미지 필요
- VERSION.sh에
UBUNTU_VERSION=16.04
를 넣고 
- build.sh 실행

2.2 우분투 14.04.2로 설치할 경우
- ubuntu-14.04.2-server-amd64.iso 이미지 필요
- VERSION.sh에
UBUNTU_VERSION=14.04.2
를 넣고 
- build.sh 실행

2.3 우분투 12.04.5로 설치할 경우
- ubuntu-12.04.5-server-amd64.iso 이미지 필요
- VERSION.sh에
UBUNTU_VERSION=12.04.5
를 넣고 
- build.sh 실행



TODO:
만약 우분투 12.04LTS 또는 14.04LTS 인 경우,
CVE-2016-0728 버그패치 커널 적용해야함
http://www.ubuntu.com/usn/usn-2872-2/
http://people.canonical.com/~ubuntu-security/cve/2016/CVE-2016-0728.html
