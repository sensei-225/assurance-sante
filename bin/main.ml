(* PharmaSafe MVP - Backend API *)

open Yojson.Safe

(* ============= DATA (Statique pour MVP) ============= *)

let medications = [
  ("3400123456789", "Doliprane 1000mg", "Paracétamol", 2.50, 0.65);
  ("3400987654321", "Amoxicilline 500mg", "Amoxicilline", 5.00, 0.65);
  ("3400111222333", "Artémether/Luméfantrine", "ACT Paludisme", 12.00, 1.00);
  ("3400444555666", "Metformine 1000mg", "Metformine", 3.50, 0.65);
  ("3400777888999", "Amlodipine 10mg", "Amlodipine", 4.20, 0.65);
  ("3400123123123", "Aspirine 100mg", "Acide acétylsalicylique", 1.80, 0.65);
  ("3400456456456", "Oméprazole 20mg", "Oméprazole", 6.50, 0.65);
  ("3400789789789", "Salbutamol 100mcg", "Salbutamol", 8.00, 0.65);
]

(* ============= HELPERS ============= *)

let medication_to_json cip name dci price rate =
  `Assoc [
    ("cip", `String cip);
    ("name", `String name);
    ("dci", `String dci);
    ("price", `Float price);
    ("reimbursement_rate", `Float rate);
    ("reimbursement_amount", `Float (price *. rate));
    ("patient_pays", `Float (price *. (1.0 -. rate)));
    ("in_stock", `Bool true);
  ]

(* ============= ROUTES ============= *)

let home_page _request =
  Dream.html {|
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>PharmaSafe API v0.2</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { 
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      min-height: 100vh;
      padding: 20px;
    }
    .container {
      max-width: 900px;
      margin: 40px auto;
      background: white;
      border-radius: 20px;
      box-shadow: 0 20px 60px rgba(0,0,0,0.3);
      overflow: hidden;
    }
    .header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 40px;
      text-align: center;
    }
    .header h1 { font-size: 2.5em; margin-bottom: 10px; }
    .badge {
      display: inline-block;
      background: rgba(255,255,255,0.2);
      padding: 5px 15px;
      border-radius: 20px;
      font-size: 0.9em;
      margin-top: 10px;
    }
    .status {
      background: #10b981;
      color: white;
      padding: 8px 20px;
      border-radius: 8px;
      display: inline-block;
      margin-top: 15px;
      font-weight: bold;
    }
    .content { padding: 40px; }
    h2 {
      color: #667eea;
      margin: 30px 0 15px 0;
      font-size: 1.5em;
    }
    .endpoint {
      background: #f8fafc;
      padding: 15px;
      margin: 10px 0;
      border-radius: 8px;
      border-left: 4px solid #667eea;
    }
    code {
      background: #e2e8f0;
      padding: 3px 8px;
      border-radius: 4px;
      font-family: monospace;
      color: #dc2626;
      font-size: 0.95em;
    }
    .method {
      display: inline-block;
      background: #667eea;
      color: white;
      padding: 3px 10px;
      border-radius: 4px;
      font-weight: bold;
      font-size: 0.85em;
      margin-right: 10px;
    }
    .footer {
      background: #f8fafc;
      padding: 30px 40px;
      border-top: 1px solid #e2e8f0;
      color: #64748b;
    }
    .success { color: #10b981; font-weight: bold; }
    .note { 
      background: #fef3c7; 
      border-left: 4px solid #f59e0b;
      padding: 15px;
      margin: 20px 0;
      border-radius: 8px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>🚀 PharmaSafe</h1>
      <div class="badge">API v0.2 - MVP Ready</div>
      <div class="status">✅ Backend LIVE</div>
    </div>
    
    <div class="content">
      <p style="font-size: 1.1em; color: #64748b; margin-bottom: 20px;">
        L'OS Santé pour l'Afrique - API Backend
      </p>

      <div class="note">
        <strong>📝 Note MVP:</strong> PostgreSQL configuré mais données en mémoire pour l'instant.
        Migration complète prévue Semaine 2.
      </div>

      <h2>📡 Endpoints Disponibles</h2>
      
      <div class="endpoint">
        <span class="method">GET</span>
        <code>/api/health</code>
        <p style="margin-top: 8px; color: #64748b;">Health check système</p>
      </div>
      
      <div class="endpoint">
        <span class="method">GET</span>
        <code>/api/medications</code>
        <p style="margin-top: 8px; color: #64748b;">Liste tous les médicaments</p>
      </div>
      
      <div class="endpoint">
        <span class="method">GET</span>
        <code>/api/medications/:cip</code>
        <p style="margin-top: 8px; color: #64748b;">Recherche par code CIP</p>
      </div>
      
      <div class="endpoint">
        <span class="method">GET</span>
        <code>/api/stats</code>
        <p style="margin-top: 8px; color: #64748b;">Statistiques plateforme</p>
      </div>

      <h2>💊 Exemples</h2>
      <div style="background: #1e293b; color: #e2e8f0; padding: 20px; border-radius: 8px;">
        <pre style="margin: 0;">curl http://localhost:8080/api/health

curl http://localhost:8080/api/medications

curl http://localhost:8080/api/medications/3400123456789

# Médicament inexistant
curl http://localhost:8080/api/medications/9999999999999</pre>
      </div>

      <h2>✅ Status MVP</h2>
      <p class="success">✓ Backend opérationnel</p>
      <p class="success">✓ 8 médicaments disponibles</p>
      <p class="success">✓ API REST complète</p>
      <p class="success">✓ Ready pour démo assureurs</p>
    </div>

    <div class="footer">
      <strong>🛠️ Stack:</strong> OCaml 5.4.0 + Dream Framework<br>
      <strong>🗄️ Storage:</strong> In-Memory (PostgreSQL ready)<br>
      <strong>📅 Started:</strong> 21 Oct 2025<br>
      <strong>🎯 Next:</strong> Business Plan + Pitch Deck
    </div>
  </div>
</body>
</html>
  |}

let health_check _request =
  let response = `Assoc [
    ("status", `String "healthy");
    ("service", `String "pharmasafe");
    ("version", `String "0.2.0");
    ("database", `String "ready");
    ("medications_count", `Int (List.length medications));
    ("timestamp", `Int (int_of_float (Unix.time ())));
  ] in
  Dream.json (to_string response)

let list_medications _request =
  let json_meds = List.map (fun (cip, name, dci, price, rate) ->
    medication_to_json cip name dci price rate
  ) medications in
  let response = `Assoc [
    ("count", `Int (List.length json_meds));
    ("medications", `List json_meds);
  ] in
  Dream.json (to_string response)

let get_medication request =
  let cip = Dream.param request "cip" in
  match List.find_opt (fun (c, _, _, _, _) -> c = cip) medications with
  | Some (cip, name, dci, price, rate) ->
      let response = `Assoc [
        ("found", `Bool true);
        ("medication", medication_to_json cip name dci price rate);
      ] in
      Dream.json (to_string response)
  | None ->
      let response = `Assoc [
        ("found", `Bool false);
        ("cip", `String cip);
        ("error", `String "Medication not found in database");
      ] in
      Dream.json ~status:`Not_Found (to_string response)

let platform_stats _request =
  let response = `Assoc [
    ("pharmacies_connected", `Int 0);
    ("doctors_connected", `Int 0);
    ("insurers_connected", `Int 0);
    ("medications_database", `Int (List.length medications));
    ("prescriptions_today", `Int 0);
    ("fraud_detected_today", `Int 0);
    ("uptime_hours", `Float 1.0);
    ("mvp_status", `String "operational");
  ] in
  Dream.json (to_string response)

(* ============= SERVER ============= *)

let () =
  Dream.run ~port:8080
  @@ Dream.logger
  @@ Dream.router [
    Dream.get "/"                       home_page;
    Dream.get "/api/health"             health_check;
    Dream.get "/api/medications"        list_medications;
    Dream.get "/api/medications/:cip"   get_medication;
    Dream.get "/api/stats"              platform_stats;
  ]
