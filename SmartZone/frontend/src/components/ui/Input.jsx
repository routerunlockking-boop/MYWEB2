export default function Input({ label, ...props }) {
  return (
    <div className="mb-3">
      {label && <label className="block text-sm font-medium mb-1 text-gray-700">{label}</label>}
      <input {...props} className="w-full p-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-blue-400 outline-none transition" />
    </div>
  );
}