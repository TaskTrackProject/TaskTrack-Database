CREATE TABLE IF NOT EXISTS "SystemAccount" (
    "AccountID"     SERIAL          PRIMARY KEY,
    "FullName"      VARCHAR(200)    NOT NULL,
    "Email"         VARCHAR(254)    NOT NULL UNIQUE,
    "PasswordHash"  VARCHAR(100)    NOT NULL,
    "Role"          SMALLINT        NOT NULL DEFAULT 0 CHECK ("Role" IN (0, 1)),
    "CreatedDate"   TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE "Task"
    ADD COLUMN IF NOT EXISTS "CreatedByAccountID" INT NULL;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_constraint WHERE conname = 'FK_Task_SystemAccount'
    ) THEN
        ALTER TABLE "Task"
            ADD CONSTRAINT "FK_Task_SystemAccount"
            FOREIGN KEY ("CreatedByAccountID")
            REFERENCES "SystemAccount" ("AccountID") ON DELETE RESTRICT;
    END IF;
END $$;

-- =======================
-- Password: 1234567890
-- =======================
INSERT INTO "SystemAccount"
(
    "FullName",
    "Email",
    "PasswordHash",
    "Role"
)
VALUES
(
    'System Admin',
    'admin@tasktrack.com',
    '$2y$10$yBMXgsPcn..6sYcGE8KWWO/6vhsDvV4lHlJAkfKdq2e3VZlRtgXXi',
    1
);
