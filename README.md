# ada

Sua aplicação irá rodar na nuvem e precisa de uma VPC configurada corretamente para sua execução.
Crie uma VPC com três subnets privadas e três subnets públicas. 
As privadas não podem ser acessadas diretamente da rede externa, as públicas devem estar expostas publicamente com os devidos cuidados.
Sua rede será pequena, escolha um range de IP adequado e justifique-o. A VPC deve ser criada utilizando IaC.

A minha escolha foi o terraform, criada a estrutura em 5 arquivos, dois principais que é o vpc.yaml responsavel pela criação de toda VPC, inclusive para 
uma melhor arquitetura do projeto foi criado um natgw(para se precisar manter apenas maquinas privadas).

A autenticação sera com variaveis de ambiente, passando o arquivo json gerado pela cloud com essa finalidade:
GOOGLE_CREDENTIALS

O arquivo de variaveis é onde mantemos todos valores para a criação.

**Aconselho usar o terraform cloud para gerenciamento de locks e states, senão temos que declarar onde sera armazenado esses arquivos segue exemplo abaixo.
resource "random_id" "bucket_prefix" {
byte_length = 8
}

resource "google_storage_bucket" "default" {
name          = "nome-bucket"
force_destroy = false
location      = "US"
storage_class = "STANDARD"
versioning {
enabled = true
}
}
backend.tf
terraform {
backend "gcs" {
bucket  = "nome-bucket"
prefix  = "terraform/state"
}
}

** OUtro ponto seria o setup do service mesh istio para fornecer um leque de recursos de network e rotas, um deles é o ingress.
Setup istio:
istioctl install --set profile=default -y --set meshConfig.accessLogFile=/dev/stdout --set meshConfig.defaultConfig.gatewayTopology.numTrustedProxies=2
Configurar um gateway do istio :
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
name: ada-dev-gateway
namespace: default
spec:
selector:
istio: ingressgateway
servers:
- hosts:
    - '*.ada.dev'
    - 'ada.dev'
      port:
      name: http
      number: 80
      protocol: HTTP

** Até onde entendi era so criação da infra basica, sem pensar em CICD dos MS.
Se precisar disso um resumo é aproveitar o proprio github actions para disparar o CI(build e criação da imagem baseado no DockerFile), 
subir a nova imagem para um registry e depois disso criação dos manifestos de CD para dentro de um repo(manifestos k8s), e ṕodemos usar 
uma ferramenta por exemplo como o ArgoCD para fazer esse sync e o deploy.