import { Link } from "react-router";
import { ShoppingBag, BookOpen, Users, TrendingUp } from "lucide-react";
import { Button } from "../components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "../components/ui/card";

export default function Home() {
  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="bg-gradient-to-br from-blue-600 to-blue-800 text-white py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-3xl mx-auto">
            <h1 className="text-4xl sm:text-5xl font-bold mb-6">
              Bienvenido a StudyShareUDD
            </h1>
            <p className="text-xl mb-8 text-blue-100">
              La plataforma exclusiva para estudiantes UDD donde puedes comprar y vender
              materiales de curso, y compartir apuntes de forma colaborativa.
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Link to="/marketplace">
                <Button size="lg" variant="secondary" className="w-full sm:w-auto">
                  <ShoppingBag className="mr-2 size-5" />
                  Ver Marketplace
                </Button>
              </Link>
              <Link to="/notes">
                <Button size="lg" variant="outline" className="w-full sm:w-auto bg-white/10 text-white border-white hover:bg-white/20">
                  <BookOpen className="mr-2 size-5" />
                  Explorar Apuntes
                </Button>
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <h2 className="text-3xl font-bold text-center mb-12 text-gray-900">
            ¿Qué puedes hacer en StudyShareUDD?
          </h2>
          <div className="grid md:grid-cols-3 gap-8">
            <Card>
              <CardHeader>
                <div className="bg-blue-100 w-12 h-12 rounded-lg flex items-center justify-center mb-4">
                  <ShoppingBag className="size-6 text-blue-600" />
                </div>
                <CardTitle>Marketplace Estudiantil</CardTitle>
                <CardDescription>
                  Compra y vende equipos especializados que usaste solo una vez para algún curso
                </CardDescription>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-gray-600">
                  Desde cámaras profesionales para cine hasta microscopios para medicina.
                  Ahorra dinero comprando de tus compañeros.
                </p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <div className="bg-green-100 w-12 h-12 rounded-lg flex items-center justify-center mb-4">
                  <BookOpen className="size-6 text-green-600" />
                </div>
                <CardTitle>Centro Colaborativo</CardTitle>
                <CardDescription>
                  Accede a apuntes gratuitos de tus cursos compartidos por otros estudiantes
                </CardDescription>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-gray-600">
                  Apuntes, resúmenes, formularios y guías de estudio de todas las facultades
                  disponibles de forma gratuita.
                </p>
              </CardContent>
            </Card>

            <Card>
              <CardHeader>
                <div className="bg-purple-100 w-12 h-12 rounded-lg flex items-center justify-center mb-4">
                  <Users className="size-6 text-purple-600" />
                </div>
                <CardTitle>Comunidad UDD</CardTitle>
                <CardDescription>
                  Conecta con estudiantes de todas las facultades de la universidad
                </CardDescription>
              </CardHeader>
              <CardContent>
                <p className="text-sm text-gray-600">
                  Una plataforma exclusiva y segura para la comunidad estudiantil de la
                  Universidad del Desarrollo.
                </p>
              </CardContent>
            </Card>
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="py-16 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="grid md:grid-cols-3 gap-8 text-center">
            <div>
              <div className="bg-blue-600 text-white w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <TrendingUp className="size-8" />
              </div>
              <div className="text-4xl font-bold text-gray-900 mb-2">500+</div>
              <div className="text-gray-600">Productos Disponibles</div>
            </div>
            <div>
              <div className="bg-green-600 text-white w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <BookOpen className="size-8" />
              </div>
              <div className="text-4xl font-bold text-gray-900 mb-2">1,200+</div>
              <div className="text-gray-600">Apuntes Compartidos</div>
            </div>
            <div>
              <div className="bg-purple-600 text-white w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <Users className="size-8" />
              </div>
              <div className="text-4xl font-bold text-gray-900 mb-2">3,500+</div>
              <div className="text-gray-600">Estudiantes Activos</div>
            </div>
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-16 bg-blue-600 text-white">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl font-bold mb-4">¿Listo para empezar?</h2>
          <p className="text-xl mb-8 text-blue-100">
            Únete a la comunidad StudyShareUDD y aprovecha al máximo tus recursos académicos
          </p>
          <div className="flex flex-col sm:flex-row gap-4 justify-center">
            <Link to="/marketplace">
              <Button size="lg" variant="secondary" className="w-full sm:w-auto">
                Explorar Marketplace
              </Button>
            </Link>
            <Link to="/notes">
              <Button size="lg" variant="outline" className="w-full sm:w-auto bg-white/10 text-white border-white hover:bg-white/20">
                Ver Apuntes
              </Button>
            </Link>
          </div>
        </div>
      </section>
    </div>
  );
}
