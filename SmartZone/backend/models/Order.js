import mongoose from 'mongoose';

const orderSchema = new mongoose.Schema({
  customerName: { type: String, required: true },
  phone: { type: String, required: true },
  address: { type: String, required: true },
  district: { type: String, required: true },
  items: [{ name: String, price: Number, qty: Number }],
  paymentMethod: { type: String, enum: ['COD', 'BANK_TRANSFER'], default: 'COD' },
  paymentSlipImage: { type: String },
  totalPrice: { type: Number, required: true },
  status: { type: String, default: 'PENDING' }
}, { timestamps: true });

orderSchema.virtual('orderId').get(function() {
  return `SZ-${this._id.toString().slice(-8).toUpperCase()}`;
});

export default mongoose.model('Order', orderSchema);