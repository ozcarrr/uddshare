import { useParams, Link } from "react-router";
import { ArrowLeft, Download, Star, FileText, User, Calendar, BookOpen, GraduationCap } from "lucide-react";
import { notes } from "../data/mockData";
import { Button } from "../components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "../components/ui/card";
import { Badge } from "../components/ui/badge";
import { Separator } from "../components/ui/separator";

export default function NoteDetail() {
  const { id } = useParams();
  const note = notes.find((n) => n.id === id);

  if (!note) {
    return (
      <div className="min-h-screen bg-gray-50 py-12">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h1 className="text-2xl font-bold text-gray-900 mb-4">Apunte no encontrado</h1>
          <Link to="/notes">
            <Button variant="outline">
              <ArrowLeft className="mr-2 size-4" />
              Volver al Centro Colaborativo
            </Button>
          </Link>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Back Button */}
        <Link to="/notes" className="inline-flex items-center text-gray-600 hover:text-gray-900 mb-6">
          <ArrowLeft className="mr-2 size-4" />
          Volver al Centro Colaborativo
        </Link>

        {/* Main Card */}
        <div className="bg-white rounded-lg shadow-sm p-8 mb-6">
          <div className="flex items-start gap-4 mb-6">
            <div className="bg-green-100 p-4 rounded-lg">
              <FileText className="size-8 text-green-600" />
            </div>
            <div className="flex-1">
              <div className="flex items-start justify-between gap-4 mb-2">
                <h1 className="text-3xl font-bold text-gray-900">{note.title}</h1>
                <Badge variant="secondary">{note.fileType}</Badge>
              </div>
              <p className="text-gray-600 text-lg">{note.description}</p>
            </div>
          </div>

          <Separator className="my-6" />

          <div className="grid sm:grid-cols-2 gap-6 mb-6">
            <div className="flex items-start gap-3">
              <BookOpen className="size-5 text-gray-400 mt-0.5 flex-shrink-0" />
              <div>
                <p className="font-medium text-gray-900">Curso</p>
                <p className="text-gray-600">{note.course}</p>
              </div>
            </div>

            <div className="flex items-start gap-3">
              <GraduationCap className="size-5 text-gray-400 mt-0.5 flex-shrink-0" />
              <div>
                <p className="font-medium text-gray-900">Facultad</p>
                <p className="text-gray-600">{note.faculty}</p>
              </div>
            </div>

            <div className="flex items-start gap-3">
              <User className="size-5 text-gray-400 mt-0.5 flex-shrink-0" />
              <div>
                <p className="font-medium text-gray-900">Autor</p>
                <p className="text-gray-600">{note.author}</p>
              </div>
            </div>

            <div className="flex items-start gap-3">
              <Calendar className="size-5 text-gray-400 mt-0.5 flex-shrink-0" />
              <div>
                <p className="font-medium text-gray-900">Fecha de Subida</p>
                <p className="text-gray-600">
                  {new Date(note.dateUploaded).toLocaleDateString("es-CL", {
                    year: "numeric",
                    month: "long",
                    day: "numeric",
                  })}
                </p>
              </div>
            </div>
          </div>

          <Separator className="my-6" />

          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center gap-6">
              <div className="flex items-center gap-2">
                <Download className="size-5 text-gray-400" />
                <div>
                  <p className="text-2xl font-bold text-gray-900">{note.downloads}</p>
                  <p className="text-sm text-gray-600">Descargas</p>
                </div>
              </div>
              <div className="flex items-center gap-2">
                <Star className="size-5 text-yellow-400 fill-yellow-400" />
                <div>
                  <p className="text-2xl font-bold text-gray-900">{note.rating.toFixed(1)}</p>
                  <p className="text-sm text-gray-600">Valoración</p>
                </div>
              </div>
            </div>
          </div>

          <Button size="lg" className="w-full">
            <Download className="mr-2 size-5" />
            Descargar Apunte (Gratis)
          </Button>
        </div>

        {/* Info Banner */}
        <div className="bg-blue-50 border border-blue-200 rounded-lg p-6 mb-6">
          <h3 className="font-semibold text-blue-900 mb-2">Sobre el Centro Colaborativo</h3>
          <p className="text-blue-800 text-sm">
            Todos los apuntes en StudyShareUDD son completamente gratuitos y compartidos por
            estudiantes para estudiantes. Al descargar, te invitamos a valorar el material para
            ayudar a otros compañeros.
          </p>
        </div>

        {/* Related Notes */}
        <div className="mt-8">
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Apuntes Relacionados</h2>
          <div className="grid sm:grid-cols-2 gap-6">
            {notes
              .filter((n) => n.id !== note.id && n.faculty === note.faculty)
              .slice(0, 4)
              .map((relatedNote) => (
                <Link key={relatedNote.id} to={`/notes/${relatedNote.id}`}>
                  <Card className="h-full hover:shadow-lg transition-shadow cursor-pointer">
                    <CardHeader>
                      <div className="flex items-start justify-between gap-2 mb-2">
                        <div className="bg-green-100 p-2 rounded-lg">
                          <FileText className="size-5 text-green-600" />
                        </div>
                        <Badge variant="secondary" className="text-xs">
                          {relatedNote.fileType}
                        </Badge>
                      </div>
                      <CardTitle className="text-base line-clamp-2">{relatedNote.title}</CardTitle>
                    </CardHeader>
                    <CardContent>
                      <div className="space-y-2">
                        <p className="text-sm text-gray-600">{relatedNote.course}</p>
                        <div className="flex items-center gap-4 text-sm text-gray-600">
                          <div className="flex items-center gap-1">
                            <Download className="size-4" />
                            <span>{relatedNote.downloads}</span>
                          </div>
                          <div className="flex items-center gap-1">
                            <Star className="size-4 fill-yellow-400 text-yellow-400" />
                            <span>{relatedNote.rating.toFixed(1)}</span>
                          </div>
                        </div>
                      </div>
                    </CardContent>
                  </Card>
                </Link>
              ))}
          </div>
        </div>
      </div>
    </div>
  );
}
