import { API_BASE_URL, authHeaders } from './config';

export type SummaryReport = {
  gmv_7d: number;
  orders_bnpl: number;
  avg_ticket: number;
  deliveries_complete: number;
  top_categories: { name: string; gmv: number }[];
};

export const reportingApi = {
  summary: async (token: string): Promise<SummaryReport> => {
    const res = await fetch(`${API_BASE_URL}/admin/reporting/summary`, { headers: authHeaders(token) });
    if (!res.ok) throw new Error('Error al cargar resumen');
    return res.json();
  },
};
