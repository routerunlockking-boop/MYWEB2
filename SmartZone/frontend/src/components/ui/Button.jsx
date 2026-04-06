export default function Button({ children, onClick, disabled, className = '', type = 'button' }) {
  return (
    <button type={type} onClick={onClick} disabled={disabled} className={`px-4 py-3 rounded-xl font-medium transition-all ${disabled ? 'opacity-50 cursor-not-allowed' : 'hover:opacity-90'} ${className}`}>
      {children}
    </button>
  );
}