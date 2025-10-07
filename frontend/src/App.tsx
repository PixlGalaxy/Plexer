import Navbar from "./components/Navbar";

export default function App() {
  return (
    <div className="bg-gray-950 text-gray-100 min-h-screen">
      <Navbar />
      <div className="max-w-4xl mx-auto p-6">
        <h1 className="text-3xl font-bold mb-4">Plexxer</h1>
        <p className="opacity-70">
          Secure torrent downloader with VPN protection.
        </p>
      </div>
    </div>
  );
}
