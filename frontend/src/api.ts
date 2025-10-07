import axios from "axios";

const base = import.meta.env.VITE_API_BASE || "http://localhost:8080";

export const api = {
  vpnStatus: () => axios.get(`${base}/api/vpn/status`).then(r => r.data),
  prepare: (link: string, target: "Movies" | "TvShows") =>
    axios.post(`${base}/api/torrents/prepare`, { link, target }).then(r => r.data),
  select: (hash: string, selectedIds: number[]) =>
    axios.post(`${base}/api/torrents/select`, { hash, selectedIds }).then(r => r.data),
  start: (hash: string) =>
    axios.post(`${base}/api/torrents/start`, { hash }).then(r => r.data),
  status: (hash: string) =>
    axios.get(`${base}/api/torrents/status`, { params: { hash } }).then(r => r.data),
};
