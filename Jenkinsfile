pipeline {
    agent any

    environment {
        CONTAINER_ID = ''  // Stockera l'ID du conteneur Docker exécuté
        SUM_PY_PATH = './sum.py'  // Chemin du script Python sur la machine locale
        DIR_PATH = './'  // Chemin vers le répertoire contenant le Dockerfile
        TEST_FILE_PATH = './test_variables.txt'  // Chemin vers le fichier de test
        IMAGE_NAME = 'sum-python'  // Nom de l'image Docker
        CONTAINER_NAME = 'sum-container'  // Nom du conteneur Docker
        DOCKERHUB_USER = 'chahd1111'  // Ton nom d’utilisateur DockerHub
        DOCKERHUB_REPO = 'pipeline_chahd'  // Nom de ton repo DockerHub
    }

    stages {
        stage('Build') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME} ${DIR_PATH}"
                }
            }
        }

        stage('Run') {
            steps {
                script {
                    def output = sh(script: "docker run -d --name ${CONTAINER_NAME} ${IMAGE_NAME}", returnStdout: true).trim()
                    CONTAINER_ID = output
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    def testLines = readFile(TEST_FILE_PATH).split('\n')

                    for (line in testLines) {
                        def vars = line.split(' ')
                        def arg1 = vars[0]
                        def arg2 = vars[1]
                        def expectedSum = vars[2].toFloat()

                        def output = sh(script: "docker exec ${CONTAINER_NAME} python /app/sum.py ${arg1} ${arg2}", returnStdout: true).trim()
                        def result = output.toFloat()

                        if (result == expectedSum) {
                            echo "✅ Test réussi : ${arg1} + ${arg2} = ${result}"
                        } else {
                            error "❌ Test échoué : ${arg1} + ${arg2} devrait être ${expectedSum}, mais a retourné ${result}"
                        }
                    }
                }
            }
        }

        stage('Clean Up') {
            steps {
                script {
                    sh "docker stop ${CONTAINER_NAME}"
                    sh "docker rm ${CONTAINER_NAME}"
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh "docker login -u ${DOCKERHUB_USER} -p Outerbanks2021"
                    sh "docker tag ${IMAGE_NAME} ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest"
                    sh "docker push ${DOCKERHUB_USER}/${DOCKERHUB_REPO}:latest"
                }
            }
        }
    }

    post {
        always {
            script {
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"
            }
        }
    }
}
