export default function Login() {
  return (
    <div className="max-w-md mx-auto bg-white p-8 rounded-2xl shadow-md mt-8 text-center">
      <h2 className="text-2xl font-bold mb-6">🔐 Login</h2>
      <input placeholder="Email" className="w-full p-3 border rounded-xl mb-3" />
      <input type="password" placeholder="Password" className="w-full p-3 border rounded-xl mb-4" />
      <button className="w-full bg-blue-600 text-white py-3 rounded-xl font-bold hover:bg-blue-700">Sign In</button>
    </div>
  );
}