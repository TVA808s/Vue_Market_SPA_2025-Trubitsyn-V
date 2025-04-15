import { createClient } from '@supabase/supabase-js'
import { table } from 'console'
const supabase = createClient(process.env.VITE_SUPABASE_URL,
  process.env.VITE_SUPABASE_KEY)
