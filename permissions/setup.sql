CREATE TABLE "guides"."permissions" (
    "id" SMALLINT PRIMARY KEY,
    "reference" TEXT,
    "description" TEXT,
    "is-administration" BOOLEAN
);
