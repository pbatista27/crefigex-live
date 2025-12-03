import { useState } from 'react';

export const useToast = () => {
  const [message, setMessage] = useState<string | null>(null);
  const [variant, setVariant] = useState<'success' | 'error'>('success');

  const show = (msg: string, type: 'success' | 'error' = 'success') => {
    setVariant(type);
    setMessage(msg);
    setTimeout(() => setMessage(null), 2500);
  };

  const Toast = () =>
    message ? (
      <div
        style={{
          position: 'fixed',
          bottom: 20,
          right: 20,
          padding: '12px 16px',
          borderRadius: 10,
          background: variant === 'success' ? 'rgba(34,197,94,0.15)' : 'rgba(239,68,68,0.15)',
          color: variant === 'success' ? '#22c55e' : '#f87171',
          border: `1px solid ${variant === 'success' ? 'rgba(34,197,94,0.4)' : 'rgba(239,68,68,0.4)'}`,
          boxShadow: '0 10px 30px rgba(0,0,0,0.12)',
          zIndex: 2000,
        }}
      >
        {message}
      </div>
    ) : null;

  return { show, Toast };
};
