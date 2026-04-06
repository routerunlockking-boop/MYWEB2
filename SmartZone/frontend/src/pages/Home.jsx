export default function Home() {
  return (
    <div className="text-center py-10">
      <h2 className="text-3xl font-bold mb-4">🇱🇰 ශ්‍රී ලංකාවේ ප්‍රමුඛතම WiFi උපකරණ අලෙවිසැල</h2>
      <p className="text-gray-600 mb-6">රවුටර්, මෙෂ් සිස්ටම්, ඇක්සස් පොයින්ට් සහ අමතර කොටස්</p>
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {['WiFi 6 Router', 'Mesh System', 'Network Switch'].map(item => (
          <div key={item} className="bg-white p-6 rounded-2xl shadow-md hover:shadow-lg transition">
            <h3 className="font-bold text-lg">{item}</h3>
            <p className="text-gray-500 text-sm">Rs. 8,500 සිට</p>
          </div>
        ))}
      </div>
    </div>
  );
}