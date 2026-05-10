import { useState } from "react";
import { Link } from "react-router";
import { Search, Download, Star, FileText, SlidersHorizontal } from "lucide-react";
import { notes, faculties } from "../data/mockData";
import { Input } from "../components/ui/input";
import { Button } from "../components/ui/button";
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "../components/ui/card";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "../components/ui/select";
import { Badge } from "../components/ui/badge";

export default function Notes() {
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedFaculty, setSelectedFaculty] = useState<string>("all");
  const [showFilters, setShowFilters] = useState(false);

  const filteredNotes = notes.filter((note) => {
    const matchesSearch =
      note.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      note.description.toLowerCase().includes(searchQuery.toLowerCase()) ||
      note.course.toLowerCase().includes(searchQuery.toLowerCase());

    const matchesFaculty =
      selectedFaculty === "all" || note.faculty === selectedFaculty;

    return matchesSearch && matchesFaculty;
  });

  return (
    <div className="min-h-screen bg-gray-50 py-8">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        {/* Header */}
        <div className="mb-8">
          <h1 className="text-3xl font-bold text-gray-900 mb-2">Centro Colaborativo</h1>
          <p className="text-gray-600">
            Apuntes y materiales de estudio compartidos gratuitamente por la comunidad UDD
          </p>
        </div>

        {/* Search and Filters */}
        <div className="bg-white rounded-lg shadow-sm p-6 mb-8">
          <div className="flex flex-col lg:flex-row gap-4">
            {/* Search Bar */}
            <div className="flex-1 relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 size-5" />
              <Input
                type="text"
                placeholder="Buscar apuntes, cursos..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="pl-10"
              />
            </div>

            {/* Filter Button Mobile */}
            <Button
              variant="outline"
              onClick={() => setShowFilters(!showFilters)}
              className="lg:hidden"
            >
              <SlidersHorizontal className="mr-2 size-4" />
              Filtros
            </Button>
          </div>

          {/* Filters */}
          <div className={`${showFilters ? "block" : "hidden"} lg:block mt-4`}>
            <div>
              <label className="text-sm font-medium text-gray-700 mb-2 block">
                Facultad
              </label>
              <Select value={selectedFaculty} onValueChange={setSelectedFaculty}>
                <SelectTrigger>
                  <SelectValue placeholder="Todas las facultades" />
                </SelectTrigger>
                <SelectContent>
                  <SelectItem value="all">Todas las facultades</SelectItem>
                  {faculties.map((faculty) => (
                    <SelectItem key={faculty} value={faculty}>
                      {faculty}
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
          </div>
        </div>

        {/* Results Count */}
        <div className="mb-6">
          <p className="text-gray-600">
            {filteredNotes.length} {filteredNotes.length === 1 ? "apunte encontrado" : "apuntes encontrados"}
          </p>
        </div>

        {/* Notes Grid */}
        {filteredNotes.length === 0 ? (
          <div className="text-center py-12">
            <p className="text-gray-500 text-lg">No se encontraron apuntes con estos filtros.</p>
            <Button
              variant="outline"
              className="mt-4"
              onClick={() => {
                setSearchQuery("");
                setSelectedFaculty("all");
              }}
            >
              Limpiar filtros
            </Button>
          </div>
        ) : (
          <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredNotes.map((note) => (
              <Link key={note.id} to={`/notes/${note.id}`}>
                <Card className="h-full hover:shadow-lg transition-shadow cursor-pointer">
                  <CardHeader>
                    <div className="flex items-start justify-between gap-2 mb-2">
                      <div className="bg-green-100 p-3 rounded-lg">
                        <FileText className="size-6 text-green-600" />
                      </div>
                      <Badge variant="secondary" className="text-xs">
                        {note.fileType}
                      </Badge>
                    </div>
                    <CardTitle className="line-clamp-2">{note.title}</CardTitle>
                    <CardDescription className="line-clamp-2">
                      {note.description}
                    </CardDescription>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-3">
                      <div>
                        <p className="text-sm font-medium text-gray-900">{note.course}</p>
                        <p className="text-sm text-gray-600">{note.faculty}</p>
                      </div>

                      <div className="flex items-center gap-4 text-sm text-gray-600">
                        <div className="flex items-center gap-1">
                          <Download className="size-4" />
                          <span>{note.downloads}</span>
                        </div>
                        <div className="flex items-center gap-1">
                          <Star className="size-4 fill-yellow-400 text-yellow-400" />
                          <span>{note.rating.toFixed(1)}</span>
                        </div>
                      </div>
                    </div>
                  </CardContent>
                  <CardFooter className="border-t pt-4">
                    <div className="w-full">
                      <p className="text-sm text-gray-600">
                        Por: <span className="font-medium text-gray-900">{note.author}</span>
                      </p>
                      <p className="text-xs text-gray-500 mt-1">
                        {new Date(note.dateUploaded).toLocaleDateString("es-CL", {
                          year: "numeric",
                          month: "long",
                          day: "numeric",
                        })}
                      </p>
                    </div>
                  </CardFooter>
                </Card>
              </Link>
            ))}
          </div>
        )}

        {/* Info Banner */}
        <div className="mt-12 bg-blue-50 border border-blue-200 rounded-lg p-6">
          <h3 className="font-semibold text-blue-900 mb-2">
            ¿Quieres compartir tus apuntes?
          </h3>
          <p className="text-blue-800 text-sm">
            Ayuda a la comunidad UDD compartiendo tus apuntes y resúmenes. Todos los materiales
            en el Centro Colaborativo son gratuitos y están disponibles para todos los estudiantes.
          </p>
        </div>
      </div>
    </div>
  );
}
