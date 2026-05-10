import { Outlet, Link, useLocation } from "react-router";
import { BookOpen, ShoppingBag, Home } from "lucide-react";

export default function Layout() {
  const location = useLocation();
  
  const isActive = (path: string) => {
    if (path === "/" && location.pathname === "/") return true;
    if (path !== "/" && location.pathname.startsWith(path)) return true;
    return false;
  };

  return (
    <div className="min-h-screen flex flex-col bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow-sm border-b sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="flex justify-between items-center h-16">
            <Link to="/" className="flex items-center gap-2">
              <div className="bg-blue-600 text-white px-3 py-1.5 rounded-lg font-bold text-lg">
                UDD
              </div>
              <span className="font-bold text-xl text-gray-900">StudyShareUDD</span>
            </Link>

            <nav className="flex gap-1">
              <Link
                to="/"
                className={`flex items-center gap-2 px-4 py-2 rounded-lg transition-colors ${
                  isActive("/") && location.pathname === "/"
                    ? "bg-blue-50 text-blue-700"
                    : "text-gray-700 hover:bg-gray-100"
                }`}
              >
                <Home className="size-5" />
                <span className="hidden sm:inline">Inicio</span>
              </Link>
              <Link
                to="/marketplace"
                className={`flex items-center gap-2 px-4 py-2 rounded-lg transition-colors ${
                  isActive("/marketplace")
                    ? "bg-blue-50 text-blue-700"
                    : "text-gray-700 hover:bg-gray-100"
                }`}
              >
                <ShoppingBag className="size-5" />
                <span className="hidden sm:inline">Marketplace</span>
              </Link>
              <Link
                to="/notes"
                className={`flex items-center gap-2 px-4 py-2 rounded-lg transition-colors ${
                  isActive("/notes")
                    ? "bg-blue-50 text-blue-700"
                    : "text-gray-700 hover:bg-gray-100"
                }`}
              >
                <BookOpen className="size-5" />
                <span className="hidden sm:inline">Centro Colaborativo</span>
              </Link>
            </nav>
          </div>
        </div>
      </header>

      {/* Main Content */}
      <main className="flex-1">
        <Outlet />
      </main>

      {/* Footer */}
      <footer className="bg-white border-t mt-auto">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <p className="text-center text-gray-600 text-sm">
            © 2026 StudyShareUDD - Exclusivo para estudiantes de la Universidad del Desarrollo
          </p>
        </div>
      </footer>
    </div>
  );
}
