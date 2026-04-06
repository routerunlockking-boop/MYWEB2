import { useState } from 'react';
import { toast } from 'react-hot-toast';
import { Upload, MessageCircle } from 'lucide-react';
import axios from 'axios';
import Button from '../components/ui/Button';
import Input from '../components/ui/Input';

const API = import.meta.env.VITE_API_URL || 'http://localhost:3000/api';

export default function Checkout() {
  const [form, setForm] = useState({ name: '', phone: '', address: '', district: 'Colombo', payment: 'COD' });
  const [slip, setSlip] = useState(null);
  const [preview, setPreview] = useState(null);
  const [loading, setLoading] = useState(false);

  const update = (e) => setForm({ ...form, [e.target.name]: e.target.value });
  const handleFile = (e) => {
    const f = e.target.files[0];
    if (f) { setSlip(f); if (f.type.startsWith('image/')) setPreview(URL.createObjectURL(f)); }
  };

  const sendWA = (id, total) => {
    const msg = `🛒 Order: ${id}\n💰 Amount: Rs. ${total}\n📎 Slip attached.`;
    window.open(`https://wa.me/${import.meta.env.VITE_WHATSAPP_NUMBER}?text=${encodeURIComponent(msg)}`, '_blank');
  };

  const submit = async (e) => {
    e.preventDefault();
    if (form.payment === 'BANK_TRANSFER' && !slip) return toast.error('Slip එක upload කරන්න');
    setLoading(true);
    try {
      const res = await axios.post(`${API}/orders`, {
        ...form,
        items: [{ name: 'TP-Link Archer AX55', price: 18500, qty: 1 }],
        paymentSlipImage: slip ? 'uploaded' : null,
        totalPrice: 21830
      });
      toast.success(`✅ Order සාර්ථකයි! ${res.data.orderId}`);
      if (form.payment === 'BANK_TRANSFER') sendWA(res.data.orderId, res.data.total);
      setForm({ name: '', phone: '', address: '', district: 'Colombo', payment: 'COD' });
      setSlip(null); setPreview(null);
    } catch (err) {
      toast.error('Order කිරීමට නොහැක');
    } finally { setLoading(false); }
  };

  return (
    <form onSubmit={submit} className="bg-white p-6 rounded-2xl shadow-md max-w-lg mx-auto space-y-4">
      <h2 className="text-xl font-bold">🛒 Checkout</h2>
      <Input name="name" label="නම" value={form.name} onChange={update} required />
      <Input name="phone" label="දුරකථන අංකය" value={form.phone} onChange={update} required />
      <Input name="address" label="ලිපිනය" value={form.address} onChange={update} required />
      
      <select name="district" value={form.district} onChange={update} className="w-full p-3 border rounded-xl mb-3">
        {['Colombo','Gampaha','Kandy','Matara','Galle','Jaffna'].map(d => <option key={d}>{d}</option>)}
      </select>

      <div className="space-y-2 mb-3">
        <label className="flex items-center gap-2"><input type="radio" name="payment" value="COD" defaultChecked onChange={() => setForm(f => ({...f, payment: 'COD'}))} /> 💵 COD</label>
        <label className="flex items-center gap-2"><input type="radio" name="payment" value="BANK_TRANSFER" onChange={() => setForm(f => ({...f, payment: 'BANK_TRANSFER'}))} /> 🏦 Bank Transfer</label>
      </div>

      {form.payment === 'BANK_TRANSFER' && (
        <div className="bg-blue-50 p-4 rounded-xl space-y-3">
          <p className="text-sm font-medium">🏦 Commercial Bank | 1234567890 | Colombo Main</p>
          <label className="block border-2 border-dashed p-4 text-center rounded-xl cursor-pointer hover:bg-blue-100">
            {preview ? <img src={preview} className="h-32 mx-auto rounded" /> : <><Upload className="mx-auto mb-2"/> Slip එක තෝරන්න</>}
            <input type="file" accept="image/*,.pdf" className="hidden" onChange={handleFile} />
          </label>
          <Button type="button" onClick={() => sendWA('PENDING', '21,830')} className="w-full bg-green-600 text-white flex items-center justify-center gap-2">
            <MessageCircle size={18} /> Slip එක WhatsApp වලින් යවන්න
          </Button>
        </div>
      )}

      <Button type="submit" disabled={loading} className="w-full bg-blue-600 text-white font-bold">
        {loading ? 'Processing...' : 'Confirm Order'}
      </Button>
    </form>
  );
}