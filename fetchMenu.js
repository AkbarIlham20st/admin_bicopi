import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.SUPABASE_URL
const supabaseKey = process.env.SUPABASE_KEY

const supabase = createClient(supabaseUrl, supabaseKey)

async function fetchMenu() {
  const { data: menu, error } = await supabase
    .from('menu')
    .select('nama_menu')

  if (error) {
    console.error('❌ Gagal mengambil data:', error.message)
    process.exit(1)
  }

  console.log('✅ Data id_menu berhasil diambil:')
  console.table(menu)
}

fetchMenu()
