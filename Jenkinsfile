// Declarative //
pipeline {
    agent any
    
 //   environment {
   //     sonarqubeScannerHome = tool name:'SonarScannerTest'

   // }

    stages {

        stage('Build') {
            steps {
                echo 'Building..'
                sh 'cd webdemo && ./gradlew build -x test'
            }
        }

        
       stage('Test') {
            steps {
                echo 'Testing..'
                sh 'cd webdemo && ./gradlew test || true'
              //  junit '**/target/*.xml'
            }
        }

        
        
      stage('SonarQube analysis') {
           steps {
               echo "starting codeAnalyze with SonarQube......"
                script{
                def sonarqubeScannerHome = tool name:'SonarScannerTest'
                withSonarQubeEnv('SonarQubeServer') {
                   //固定使用项目根目录${basedir}下的pom.xml进行代码检查
                    sh "${sonarqubeScannerHome}/bin/sonar-scanner"
                }
            
                timeout(1) { 
                   //利用sonar webhook功能通知pipeline代码检测结果，未通过质量阈，pipeline将会fail
                    def qg = waitForQualityGate() 
                        if (qg.status != 'OK') {
                            error "未通过Sonarqube的代码质量阈检查，请及时修改！failure: ${qg.status}"
                        }
                    }
                }
            }
        }
        
     stage('Deploy') {
            steps{
                 echo 'Deploying..' 
                sh """
                    set -e
                    ssh tomcat@172.17.0.2 'bash -s' < checktomcatstatus.sh
                    cd /var/jenkins_home/workspace/Pipeline/webdemo/build/libs
                    scp webdemo.war tomcat@172.17.0.2:/opt/tomcat/webapps
                    ssh os_user@172.17.0.2 '
                        cd /opt/tomcat/bin
                        ./startup.sh
                    '
                """ 
            }
        } 
        
    }
}
