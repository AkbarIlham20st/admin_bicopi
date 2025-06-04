pipeline {
  agent any

  environment {
    SUPABASE_URL = credentials('SUPABASE_URL')
    SUPABASE_KEY = credentials('SUPABASE_KEY')
  }

  stages {
    stage('Install Dependencies') {
      steps {
        sh '''
          npm init -y
          npm install @supabase/supabase-js
        '''
      }
    }

    stage('Fetch Data from Supabase') {
      steps {
        sh 'node fetchMenu.js'
      }
    }
  }
}
