import { useState, useEffect } from 'react';

const TENANTS = [
  { id: '11111111-1111-1111-1111-111111111111', name: 'Innov8 Hub' },
  { id: '22222222-2222-2222-2222-222222222222', name: 'WorkNest' },
];

const TABS = ['members', 'rooms', 'bookings', 'access-logs'];

function App() {
  const [selectedTenant, setSelectedTenant] = useState(TENANTS[0].id);
  const [activeTab, setActiveTab] = useState('members');
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    setLoading(true);
    fetch(`http://localhost:4000/${activeTab}`, {
      headers: { 'x-tenant-id': selectedTenant },
    })
      .then((res) => res.json())
      .then((json) => {
        setData(json);
        setLoading(false);
      })
      .catch((err) => {
        console.error(err);
        setLoading(false);
      });
  }, [selectedTenant, activeTab]);

  return (
    <div className="min-h-screen bg-gray-100 p-6">
      <h1 className="text-3xl font-bold text-gray-800 mb-6">TenantVault Admin</h1>

      {/* Tenant Selector */}
      <div className="mb-4">
        <label className="font-semibold mr-2">Tenant:</label>
        <select
          value={selectedTenant}
          onChange={(e) => setSelectedTenant(e.target.value)}
          className="border rounded px-3 py-2"
        >
          {TENANTS.map((t) => (
            <option key={t.id} value={t.id}>
              {t.name}
            </option>
          ))}
        </select>
      </div>

      {/* Tabs */}
      <div className="flex gap-2 mb-4">
        {TABS.map((tab) => (
          <button
            key={tab}
            onClick={() => setActiveTab(tab)}
            className={`px-4 py-2 rounded capitalize ${
              activeTab === tab
                ? 'bg-blue-600 text-white'
                : 'bg-white text-gray-700 border'
            }`}
          >
            {tab.replace('-', ' ')}
          </button>
        ))}
      </div>

      {/* Data Table */}
      <div className="bg-white rounded shadow p-4">
        {loading ? (
          <p>Loading...</p>
        ) : data.length === 0 ? (
          <p className="text-gray-500">No data found.</p>
        ) : (
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b text-left">
                {Object.keys(data[0]).map((key) => (
                  <th key={key} className="p-2 font-semibold capitalize">
                    {key.replace('_', ' ')}
                  </th>
                ))}
              </tr>
            </thead>
            <tbody>
              {data.map((row, i) => (
                <tr key={i} className="border-b">
                  {Object.values(row).map((val, j) => (
                    <td key={j} className="p-2 truncate max-w-xs">
                      {String(val)}
                    </td>
                  ))}
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>
    </div>
  );
}

export default App;