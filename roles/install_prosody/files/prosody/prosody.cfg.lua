-- vim:ft=lua
-- Prosody XMPP Server Configuration
--
-- Information on configuring Prosody can be found on our
-- website at https://prosody.im/doc/configure
--
-- Tip: You can check that the syntax of this file is correct
-- when you have finished by running this command:
--     prosodyctl check config
-- If there are any errors, it will let you know what and where
-- they are, otherwise it will keep quiet.
--
-- Upgrading from a previous release? Check https://prosody.im/doc/upgrading
--
-- Good luck, and happy Jabbering!

---------- Server-wide settings ----------
-- Settings in this section apply to the whole server and are the default settings
-- for any virtual hosts

-- This is a (by default, empty) list of accounts that are admins
-- for the server. Note that you must create the accounts separately
-- (see https://prosody.im/doc/creating_accounts for info)
-- Example: admins = { "user1@example.com", "user2@example.net" }
admins = {
    ENV_OPERATOR;
}

-- This option allows you to specify additional locations where Prosody
-- will search first for modules. For additional modules you can install, see
-- the community module repository at https://modules.prosody.im/
--plugin_paths = {}

-- This is the list of modules Prosody will load on startup.
-- Documentation for bundled modules can be found at: https://prosody.im/doc/modules
modules_enabled = {

  -- Generally required
    "disco"; -- Service discovery
    "roster"; -- Allow users to have a roster. Recommended ;)
    "saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
    "tls"; -- Add support for secure TLS on c2s/s2s connections

  -- Not essential, but recommended
    "blocklist"; -- Allow users to block communications with other users
    "bookmarks"; -- Synchronise the list of open rooms between clients
    "carbons"; -- Keep multiple online clients in sync
    "dialback"; -- Support for verifying remote servers using DNS
    "limits"; -- Enable bandwidth limiting for XMPP connections
    "pep"; -- Allow users to store public and private data in their account
    "private"; -- Legacy account storage mechanism (XEP-0049)
    "smacks"; -- Stream management and resumption (XEP-0198)
    "vcard4"; -- User profiles (stored in PEP)
    "vcard_legacy"; -- Conversion between legacy vCard and PEP Avatar, vcard

  -- Nice to have
    "account_activity"; -- Record time when an account was last used
    "cloud_notify"; -- Push notifications for mobile devices
    "csi_simple"; -- Simple but effective traffic optimizations for mobile devices
    "invites"; -- Create and manage invites
    "invites_adhoc"; -- Allow admins/users to create invitations via their client
    "invites_register"; -- Allows invited users to create accounts
    "ping"; -- Replies to XMPP pings with pongs
    "register"; -- Allow users to register on this server using a client and change passwords
    "time"; -- Let others know the time here on this server
    "uptime"; -- Report how long server has been running
    "version"; -- Replies to server version requests
    "mam"; -- Store recent messages to allow multi-device synchronization
    "turn_external"; -- Provide external STUN/TURN service for e.g. audio/video calls

  -- Admin interfaces
    "admin_adhoc"; -- Allows administration via an XMPP client that supports ad-hoc commands
    "admin_shell"; -- Allow secure administration via 'prosodyctl shell'

  -- HTTP modules
    "bosh"; -- Enable BOSH clients, aka "Jabber over HTTP"
    -- "http_openmetrics"; -- for exposing metrics to stats collectors
    "websocket"; -- XMPP over WebSockets

  -- Other specific functionality
    "announce"; -- Send announcement to all online users
    --"groups"; -- Shared roster support
    "mimicking"; -- Prevent address spoofing
    --"motd"; -- Send a message to users when they log in
    --"proxy65"; -- Enables a file transfer proxy service which clients behind NAT can use
    "s2s_bidi"; -- Bi-directional server-to-server (XEP-0288)
    "server_contact_info"; -- Publish contact information for this service
    "tombstones"; -- Prevent registration of deleted accounts
    "watchregistrations"; -- Alert admins of registrations
    "welcome"; -- Welcome users who register accounts

  -- External modules
    "block_registrations"; -- Reserve individual usernames, or those matching certain patterns.
    "firewall"; -- Loads one or more scripts, and compiles these to Lua code that reacts to stanzas flowing through Prosody
    "spam_reporting"; -- When someone reports spam or abuse, a line about this is logged and an event is fired so that other modules can act on the report
    "watch_spam_reports"; -- Sends a message to the server admins for incoming XEP-0377 spam reports
}

-- These modules are auto-loaded, but should you want
-- to disable them then uncomment them here:
modules_disabled = {
  -- "offline"; -- Store offline messages
  -- "c2s"; -- Handle client connections
  -- "s2s"; -- Handle server-to-server connections
}
-- Toggle server-to-server connections
if not ENV_S2S then
    Lua.table.insert(modules_disabled, "s2s")
end

---------- Network ----------

-- Interfaces on which to listen for XMPP over TLS client connections
-- c2s_direct_tls_interfaces = "127.0.0.1"
-- Ports on which to listen for XMPP over TLS client connections
c2s_direct_tls_ports = ENV_C2S_XMPP_PORT

-- Interfaces on which to listen for XMPP over TLS server-to-server connections
-- s2s_direct_tls_interfaces = "127.0.0.1"
-- Ports on which to listen for XMPP over TLS server-to-server connections
s2s_direct_tls_ports = ENV_S2S_XMPP_PORT

-- Ports on which builtin HTTP(s) server will listen
https_ports = {
    ENV_HTTP_SERVER_PORT;
}

-- Server's IP addresses
external_addresses = {}
-- Add IPv4 address to external_addresses table if it exists
if ENV_IPV4_ADDRESS and ENV_IPV4_ADDRESS ~= "" then
    Lua.table.insert(external_addresses, ENV_IPV4_ADDRESS)
end
-- Add IPv6 address to external_addresses table if it exists
if ENV_IPV6_ADDRESS and ENV_IPV6_ADDRESS ~= "" then
    Lua.table.insert(external_addresses, ENV_IPV6_ADDRESS)
end

-- Audio/video call relay (STUN/TURN)
-- To ensure clients connected to the server can establish connections for
-- low-latency media streaming (such as audio and video calls), it is
-- recommended to run a STUN/TURN server for clients to use. If you do this,
-- specify the details here so clients can discover it.
-- Find more information at https://prosody.im/doc/turn
if ENV_TURN_HOST and ENV_TURN_HOST ~= "" then
    -- Specify the address of the TURN service (you may use the same domain as XMPP)
    turn_external_host = ENV_TURN_HOST
    -- TURN service port
    turn_external_port = ENV_TURN_PORT
    -- This secret must be set to the same value in both Prosody and the TURN server
    turn_external_secret = ENV_TURN_SECRET
end

-- Rate limits
-- Enable rate limits for incoming client and server connections. These help
-- protect from excessive resource consumption and denial-of-service attacks.
limits = {
    c2s = {
        rate = "10kb/s";
    };
    s2sin = {
        rate = "30kb/s";
    };
}

---------- Users ----------

-- Toggle registration
if ENV_ALLOW_REGISTRATION then
    allow_registration = ENV_ALLOW_REGISTRATION
elseif not ENV_ALLOW_REGISTRATION then
    allow_registration = ENV_ALLOW_REGISTRATION
else
    allow_registration = false
end

-- Registration per-IP rate limit
min_seconds_between_registrations = 3600

-- Toggle invite only registration
if ENV_INVITE_ONLY then
    registration_invite_only = ENV_INVITE_ONLY
elseif not ENV_INVITE_ONLY then
    registration_invite_only = ENV_INVITE_ONLY
else
    registration_invite_only = false
end

-- Welcome message for the newly registered users
if ENV_WELCOME_MESSAGE and ENV_WELCOME_MESSAGE ~= "" then
    welcome_message = ENV_WELCOME_MESSAGE
end

-- Message about new registrations that is sent to admins
if ENV_REGISTRATION_MESSAGE and ENV_REGISTRATION_MESSAGE ~= "" then
    registration_notification = ENV_REGISTRATION_MESSAGE
end

-- A list of reserved usernames
block_registrations_users = {
    "operator";
    "administrator";
    "admin";
    "root";
    "postmaster";
    "xmpp";
    "jabber";
    "contact";
    "mail";
    "abuse";
}
-- Allow only simple ASCII characters in usernames
block_registrations_require = "^[a-zA-Z0-9_.-]+$"
-- Block usernames that are shorter than the given length
block_registrations_length_minimum=1
--Block usernames that are longer than the given length
block_registrations_length_maximum=23

-- Firewall ruleset files
firewall_scripts = {
    "/etc/prosody/ruleset.pfw";
}

---------- Security ----------

-- Configures ciphers per corresponding profile from Mozilla
-- Available values are: modern, intermediate, old, legacy
tls_profile = "intermediate"

-- Force clients to use encrypted connections? This option will
-- prevent clients from authenticating unless they are using encryption.
c2s_require_encryption = true

-- Force servers to use encrypted connections? This option will
-- prevent servers from authenticating unless they are using encryption.
-- Note that this is different from authentication
s2s_require_encryption = true

-- Server-to-server authentication
-- Require valid certificates for server-to-server connections?
-- If false, other methods such as dialback (DNS) may be used instead.
s2s_secure_auth = true

-- Some servers have invalid or self-signed certificates. You can list
-- remote domains here that will not be required to authenticate using
-- certificates. They will be authenticated using other methods instead,
-- even when s2s_secure_auth is enabled.

--s2s_insecure_domains = { "insecure.example" }

-- Even if you disable s2s_secure_auth, you can still require valid
-- certificates for some domains by specifying a list here.

--s2s_secure_domains = { "jabber.org" }

---------- Other ----------

-- Required for init scripts and prosodyctl
pidfile = "/var/run/prosody/prosody.pid"

-- Authentication
-- Select the authentication backend to use. The 'internal' providers
-- use Prosody's configured data storage to store the authentication data.
-- For more information see https://prosody.im/doc/authentication
authentication = "internal_hashed"

-- Many authentication providers, including the default one, allow you to
-- create user accounts via Prosody's admin interfaces. For details, see the
-- documentation at https://prosody.im/doc/creating_accounts

-- Storage
-- Select the storage backend to use. By default Prosody uses flat files
-- in its configured data directory, but it also supports more backends
-- through modules. An "sql" backend is included by default, but requires
-- additional dependencies. See https://prosody.im/doc/storage for more info.
storage = "sql" -- Default is "internal"
sql = {
    driver = "PostgreSQL";
    database = ENV_POSTGRES_DB;
    username = ENV_POSTGRES_USER;
    password = ENV_POSTGRES_PASSWORD;
    host = "postgres";
    port = 5432
}

-- Logging configuration
-- For advanced logging see https://prosody.im/doc/logging
log = {
    info = "/var/log/prosody/prosody.log"; -- Change 'info' to 'debug' for verbose logging
    error = "/var/log/prosody/prosody.err";
    -- "*syslog"; -- Uncomment this for logging to syslog
    -- "*console"; -- Log to the console, useful for debugging when running in the foreground
}

-- Uncomment to enable statistics
-- For more info see https://prosody.im/doc/statistics
-- statistics = "internal"

-- Certificates
-- Every virtual host and component needs a certificate so that clients and
-- servers can securely verify its identity. Prosody will automatically load
-- certificates/keys from the directory specified here.
-- For more information, including how to use 'prosodyctl' to auto-import certificates
-- (from e.g. Let's Encrypt) see https://prosody.im/doc/certificates

-- Location of directory to find certificates in (relative to main config file):
certificates = "certs"

----------- Virtual hosts -----------
-- You need to add a VirtualHost entry for each domain you wish Prosody to serve.
-- Settings under each VirtualHost entry apply *only* to that host.
-- Prosody requires at least one enabled VirtualHost to function. You can
-- safely remove or disable 'localhost' once you have added another.
VirtualHost (ENV_VHOST)

------ Components ------
-- You can specify components to add hosts that provide special services,
-- like multi-user conferences, and transports.
-- For more information on components, see https://prosody.im/doc/components

---Set up a MUC (multi-user chat) room server
if ENV_MUC_HOST and ENV_MUC_HOST ~= "" then
    Component (ENV_MUC_HOST) "muc"
    -- Restrict room creation to users on the service’s parent domain
    restrict_room_creation = "local"
    --- Store MUC messages in an archive and allow users to access it
    modules_enabled = {
        "muc_mam";
        "mam";
        "muc_limits";
    }
end

---Set up a file sharing component
if ENV_UPLOAD_HOST and ENV_UPLOAD_HOST ~= "" then
    Component (ENV_UPLOAD_HOST) "http_file_share"
    -- File sharing quotas
    http_file_share_size_limit = 100*1024*1024 -- 100 MiB per file
    http_file_share_daily_quota = 500*1024*1024 -- 500 MiB per day
    http_file_share_global_quota = 1000*1024*1024 -- 1 GiB total
    http_file_share_expires_after = 60 * 60 * 24 -- Expires after a day
    -- Tell Prosody we don't need server-to-server
    -- connections (s2s), because this service is
    -- only for local users anyway
    modules_disabled = {
         "s2s";
    }
end

---Set up an external component (default component port is 5347)
--
-- External components allow adding various services, such as gateways/
-- bridges to non-XMPP networks and services. For more info
-- see: https://prosody.im/doc/components#adding_an_external_component
--
--Component "gateway.example.com"
--  component_secret = "password"


---------- End of the Prosody Configuration file ----------
-- You usually **DO NOT** want to add settings here at the end, as they would
-- only apply to the last defined VirtualHost or Component.
--
-- Settings for the global section should go higher up, before the first
-- VirtualHost or Component line, while settings intended for specific hosts
-- should go under the corresponding VirtualHost or Component line.
--
-- For more information see https://prosody.im/doc/configure
