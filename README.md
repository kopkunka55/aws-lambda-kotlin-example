# AWS Lambda powered by Kotlin

Simple implementation for AWS Lambda Function with Kotlin with Blue/Green deployment using AWS CodeDeploy.

## Getting Started

### Requirements

Currently AWS Lambda Java runtime supports Java 11 (amazon-corretto-11)

* [Amazon Corretto 11](https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/downloads-list.html)

## Clone repository

```shell
git clone https://github.com/kopkunka55/aws-lambda-kotlin-ddb-stream-consumer
cd aws-lambda-kotlin-ddb-stream-consumer
```

### Build Kotlin Lambda function using Gradle

Add the following gradle script to generate an executable .jar file

```kotlin
tasks.jar {
    manifest {
        attributes["Main-Class"] = "MainKt"
    }
    configurations["compileClasspath"].forEach { file: File ->
        from(zipTree(file.absoluteFile))
    }
    duplicatesStrategy = DuplicatesStrategy.INCLUDE
}
```

Execute the following command to build Kotlin function, or just run [Gradle] -> [Tasks] -> [build]

```shell
./gradlew build
```

Once Gradle build is done. JAR artifact file will be available at 
`build/libs/aws-lambda-kotlin-1.0-SNAPSHOT.jar`. The file can be referenced 
from Terraform to deploy AWS Lambda function. 

### Initial Deployment

Initialize terraform modules

```shell
cd aws
terraform init
```

check what terraform create or update

```shell
terraform plan
```

deploy to remote resources

```shell
terraform apply
```

### Continues Deployment

Terraform automatically maps the current Lambda version to the alias defined 
at initial deployment step, and then traffic balance between current and 
previous version will be shifted gradually by AWS CodeDeploy.

```shell
./gradlew build
terraform apply
```

[Pre-defined Lambda Deployment Strategy](https://docs.aws.amazon.com/ja_jp/codedeploy/latest/userguide/deployment-configurations.html)




