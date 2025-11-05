import { useState } from 'react';
const API_URL = '/api/users';

function App() {
  const [prefix, setPrefix] = useState('sa');
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [hasFetched, setHasFetched] = useState(false);

  const fetchUsers = async (value) => {
    if (!value) {
      setHasFetched(true);
      setUsers([]);
      return;
    }

    try {
      setHasFetched(true);
      setLoading(true);
      setError('');
      const response = await fetch(`${API_URL}?prefix=${encodeURIComponent(value)}`);

      if (!response.ok) {
        throw new Error(`Error ${response.status}`);
      }

      const data = await response.json();
      setUsers(Array.isArray(data) ? data : []);
    } catch (err) {
      if (err instanceof TypeError) {
        setError('No se pudo conectar con el backend. Verifica que esté en ejecución.');
      } else {
        setError(err.message || 'Error inesperado');
      }
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    fetchUsers(prefix.trim());
  };

  return (
    <main className="app">
      <section className="card">
        <h1>Buscar usuarios</h1>
        <p>Ingresa un prefijo y obtén los usuarios desde el backend.</p>
        <form onSubmit={handleSubmit} className="form">
          <label htmlFor="prefix">Prefijo</label>
          <div className="controls">
            <input
              id="prefix"
              name="prefix"
              value={prefix}
              placeholder="Ingresa un prefijo"
              onChange={(event) => setPrefix(event.target.value)}
            />
            <button type="submit" disabled={loading || !prefix.trim()}>
              {loading ? 'Buscando…' : 'Consultar'}
            </button>
          </div>
        </form>

        {error && <p className="error">{error}</p>}

        <div className="results">
          {!hasFetched ? (
            <p>Ingresa un prefijo y presiona "Consultar".</p>
          ) : users.length === 0 && !loading && !error ? (
            <p>No se encontraron usuarios.</p>
          ) : (
            <ul>
              {users.map((user) => {
                const key = user?.id ?? user?.name ?? user;
                const label =
                  typeof user === 'string' ? user : user?.name ?? JSON.stringify(user);

                return <li key={key}>{label}</li>;
              })}
            </ul>
          )}
        </div>
      </section>
    </main>
  );
}

export default App;
