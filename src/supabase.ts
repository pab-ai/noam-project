import { createClient } from "@supabase/supabase-js";
import type { CheckIn } from "./types";
const url=import.meta.env.VITE_SUPABASE_URL,key=import.meta.env.VITE_SUPABASE_ANON_KEY;
export const syncConfigured=Boolean(url&&key);
export const supabase=syncConfigured?createClient(url,key,{auth:{persistSession:true,autoRefreshToken:true}}):null;
export async function syncCheckIns(items:CheckIn[]){if(!supabase)return{mode:"local" as const};const{data:{user}}=await supabase.auth.getUser();if(!user)return{mode:"signed-out" as const};const rows=items.map(i=>({id:i.id,user_id:user.id,check_in_date:i.date,routine:i.routine,outcome:i.outcome??null,size:i.size??null,created_at:i.createdAt,updated_at:i.updatedAt}));const{error}=await supabase.from("check_ins").upsert(rows,{onConflict:"id"});if(error)throw error;return{mode:"synced" as const}}
