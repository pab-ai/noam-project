import type { CheckIn, Settings } from "./types";
const CHECKINS="noam-checkins-v1", SETTINGS="noam-settings-v1";
export const dateKey=(date=new Date())=>new Date(date.getTime()-date.getTimezoneOffset()*60000).toISOString().slice(0,10);
export const loadCheckIns=():CheckIn[]=>{try{return JSON.parse(localStorage.getItem(CHECKINS)||"[]")}catch{return[]}};
export const saveCheckIns=(items:CheckIn[])=>localStorage.setItem(CHECKINS,JSON.stringify(items));
export const loadSettings=():Settings=>{try{return JSON.parse(localStorage.getItem(SETTINGS)||"{}")}catch{return{}}};
export const saveSettings=(s:Settings)=>localStorage.setItem(SETTINGS,JSON.stringify(s));
export async function hashPin(pin:string){const digest=await crypto.subtle.digest("SHA-256",new TextEncoder().encode(pin));return[...new Uint8Array(digest)].map(b=>b.toString(16).padStart(2,"0")).join("")}
export function exportData(checkIns:CheckIn[]){const blob=new Blob([JSON.stringify({exportedAt:new Date().toISOString(),version:1,checkIns},null,2)],{type:"application/json"});const url=URL.createObjectURL(blob),link=document.createElement("a");link.href=url;link.download=`noam-little-wins-${dateKey()}.json`;link.click();URL.revokeObjectURL(url)}
