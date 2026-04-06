import { Routes, Route } from 'react-router-dom';
import Home from './pages/Home';
import Checkout from './pages/Checkout';
import Login from './pages/Login';
import FloatingWhatsApp from './components/layout/FloatingWhatsApp';

export default function App() {
  return (
    <div className="min-h-screen flex flex-col">
      <header className="bg-white/80 backdrop-blur shadow-sm p-4 sticky top-0 z-40">
        <div className="max-w-5xl mx-auto flex justify-between items-center">
          <h1 className="text-2xl font-bold bg-gradient-to-r from-blue-600 to-cyan-500 bg-clip-text text-transparent">
            🌐 SmartZone
          </h1>
          <nav className="flex gap-4 text-sm font-medium">
            <a href="/" className="hover:text-blue-600">මුල් පිටුව</a>
            <a href="/checkout" className="hover:text-blue-600">Checkout</a>
            <a href="/login" className="hover:text-blue-600">Login</a>
          </nav>
        </div>
      </header>
      
      <main className="flex-1 p-4 max-w-5xl mx-auto w-full">
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/checkout" element={<Checkout />} />
          <Route path="/login" element={<Login />} />
        </Routes>
      </main>
      
      <FloatingWhatsApp />
    </div>
  );
}