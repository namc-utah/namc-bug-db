CREATE EXTENSION postgis;


/******************************************************************************************************************
 GEO SCHEMA
 */

CREATE SCHEMA geo;
GRANT USAGE ON SCHEMA geo TO PUBLIC;

CREATE TABLE geo.countries (
    country_id          INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    country_name        VARCHAR(50) UNIQUE NOT NULL,
    abbreviation        VARCHAR(5) NOT NULL,
    geom                GEOMETRY(MultiPolygon, 4326),
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX ix_countries_geom ON geo.countries USING GIST(geom);

CREATE TABLE geo.states (
    state_id            INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    country_id          INT NOT NULL,
    state_name          VARCHAR(50) NOT NULL,
    abbreviation        VARCHAR(2) NOT NULL,
    geom                GEOMETRY(MultiPolygon, 4326),
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_states_country_id FOREIGN KEY (country_id) REFERENCES geo.countries(country_id)
);
CREATE INDEX ix_states_country_id ON geo.states(country_id);
CREATE UNIQUE INDEX ux_states_name ON geo.states(country_id, state_name);
CREATE UNIQUE INDEX ux_states_abbreviation ON geo.states(country_id, abbreviation);
CREATE INDEX ix_states_geom ON geo.states USING GIST(geom);

CREATE TABLE geo.counties (
    county_id           INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    state_id            INT NOT NULL,
    county_name         VARCHAR(255) NOT NULL,
    geom                GEOMETRY(MultiPolygon, 4326),
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_counties_state_id FOREIGN KEY (state_id) REFERENCES geo.states(state_id)
);
CREATE INDEX ix_counties_state_id ON geo.counties(state_id);
CREATE UNIQUE INDEX ux_counties_name ON geo.counties(state_id, county_name);
CREATE INDEX ix_counties_geom ON geo.counties USING GIST(geom);

-- TODO: table design incomplete
CREATE TABLE geo.sites (
    site_id             INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    site_name           VARCHAR(50) UNIQUE NOT NULL,
    description         TEXT,
    waterbody           VARCHAR(255),
    geom                GEOMETRY(Point, 4326) NOT NULL,
    NHDPlusID           BIGINT,
    COMID               BIGINT,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX ix_sites_geom ON geo.sites USING GIST(geom);



/******************************************************************************************************************
 ENTITY SCHEMA
 */

CREATE SCHEMA entity;
GRANT USAGE ON SCHEMA entity TO PUBLIC;
-- ALTER DEFAULT PRIVILEGES IN SCHEMA entity GRANT ALL ON TABLES TO PUBLIC;

CREATE TABLE entity.entity_types (
    entity_type_id      INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    entity_type_name    VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE entity.entities (
    entity_id           INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    entity_type_id      INT NOT NULL,
    parent_id           INT,
    address1            VARCHAR(255),
    address2            VARCHAR(255),
    city                VARCHAR(255),
    state_id            INT,
    country_id          INT NOT NULL,
    zip_code            VARCHAR(20),
    phone               VARCHAR(20),
    fax                 VARCHAR(20),
    website             VARCHAR(255),
    notes               TEXT,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_entities_entity_type_id FOREIGN KEY (entity_type_id) REFERENCES entity.entity_types(entity_type_id),
    CONSTRAINT fk_entities_parent_id FOREIGN KEY (parent_id) REFERENCES entity.entities(entity_id),
    CONSTRAINT fk_entities_state_id FOREIGN KEY (state_id) REFERENCES geo.states(state_id),
    CONSTRAINT fk_entities_country_id FOREIGN KEY (country_id) REFERENCES geo.countries(country_id)
);
CREATE INDEX fx_entities_state_id ON entity.entities(state_id);
CREATE INDEX fx_entities_country_id ON entity.entities(country_id);

CREATE TABLE entity.organization_types (
    organization_type_id    INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    organization_type_name  VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE entity.organizations (
    organization_id     INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    abbreviation        VARCHAR(50),
    organization_name   VARCHAR(255),
    entity_id           INT NOT NULL,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_organizations_entity_id FOREIGN KEY (entity_id) REFERENCES entity.entities(entity_id)
);
CREATE UNIQUE INDEX ux_organizations_entity_id ON entity.organizations(entity_id);

CREATE TABLE entity.organization_types_lookup (
    organization_id         INT NOT NULL,
    organization_type_id    INT NOT NULL,

    CONSTRAINT pk_organization_types_lookup PRIMARY KEY (organization_id, organization_type_id),
    CONSTRAINT fk_organization_types_lookup_organization_type_id FOREIGN KEY (organization_type_id) REFERENCES entity.organization_types(organization_type_id),
    CONSTRAINT fk_organization_types_organization_id FOREIGN KEY (organization_id) REFERENCES entity.organizations(organization_id)
);

-- TODO: table design incomplete. Need to implement roles here.
-- TODO: do we really need gender and other non-bug identification information
CREATE TABLE entity.individuals (
    individual_id       INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    first_name          VARCHAR(50) NOT NULL,
    last_name           VARCHAR(50) NOT NULL,
    initials            VARCHAR(3) NOT NULL,
    entity_id           INT NOT NULL,
    email               VARCHAR(75) NOT NULL UNIQUE,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_individuals_entity_id FOREIGN KEY (entity_id) REFERENCES entity.entities(entity_id)
);
CREATE UNIQUE INDEX ux_individuals_entity_id ON entity.individuals(entity_id);


CREATE TABLE units (
    unit_id             INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    unit_name           VARCHAR(50) UNIQUE NOT NULL,
    abbreviation        VARCHAR(10) UNIQUE NOT NULL,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE ecosystems (
    ecosystem_id        INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    ecosystem_name      VARCHAR(10) UNIQUE NOT NULL,
    is_visible          BOOLEAN NOT NULL DEFAULT TRUE,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE systems (
    system_id           INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    system_name         VARCHAR(20) UNIQUE NOT NULL,
    ecosystem_id        INT NOT NULL,
    is_visible          BOOLEAN NOT NULL DEFAULT TRUE,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_systems_ecosystem_id FOREIGN KEY (ecosystem_id) REFERENCES ecosystems(ecosystem_id)
);
CREATE INDEX ix_systems_ecosystem_id ON systems(ecosystem_id);

-- TODO: table design incomplete
CREATE TABLE predictors (
    predictor_id        INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    predictor_name      VARCHAR(50) UNIQUE NOT NULL,
    notes               TEXT,
    unit_id             INT NOT NULL,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_predictors_unit_id FOREIGN KEY (unit_id) REFERENCES units(unit_id)
);
CREATE INDEX ix_predictors_unit_id ON predictors(unit_id);

-- TODO: table design incomplete
CREATE TABLE model_types (
    model_type_id       INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    model_type_name     VARCHAR(50) UNIQUE NOT NULL,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- TODO: table design incomplete
-- TODO: determine if state_id can be NOT NULL. Allowing NULL might enable national level models.
CREATE TABLE models (
    model_id            INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    model_name          VARCHAR(255) UNIQUE NOT NULL,
    model_type_id       INT NOT NULL,
    state_id            INT NOT NULL,
    is_active           BOOLEAN NOT NULL DEFAULT TRUE,
    notes               TEXT,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_models_model_type_id FOREIGN KEY (model_type_id) REFERENCES model_types(model_type_id),
    CONSTRAINT fk_models_state_id FOREIGN KEY (state_id) REFERENCES geo.states(state_id)
);
CREATE INDEX ix_models_model_type_id ON models(model_type_id);
CREATE INDEX ix_models_state_id ON models(state_id);

CREATE TABLE model_predictors (
    model_id            INT NOT NULL,
    predictor_id        INT NOT NULL,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT pk_model_predictors PRIMARY KEY (model_id, predictor_id),
    CONSTRAINT fk_model_predictors_model_id FOREIGN KEY (model_id) REFERENCES models(model_id),
    CONSTRAINT fk_model_predictors_predictor_id FOREIGN KEY (predictor_id) REFERENCES predictors(predictor_id)
);


-- TODO: Determine if all predictors are floating point. If not then consider either separate tables or using JSON
CREATE TABLE site_predictors (
    site_id             INT NOT NULL,
    predictor_id        INT NOT NULL,
    predictor_value     REAL,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT pk_site_predictors PRIMARY KEY (site_id, predictor_id),
    CONSTRAINT fk_site_predictors_site_id FOREIGN KEY (site_id) REFERENCES geo.sites(site_id),
    CONSTRAINT fk_site_predictors_predictor_id FOREIGN KEY (predictor_id) REFERENCES predictors(predictor_id)
);

/******************************************************************************************************************
 ORGANISM SCHEMA
 */

CREATE SCHEMA organism;
GRANT USAGE ON SCHEMA entity TO PUBLIC;

CREATE TABLE organism.levels(
    level_id       INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    level_name     VARCHAR(20) UNIQUE NOT NULL,
    level_rank     SMALLINT UNIQUE NOT NULL,

    CONSTRAINT ck_taxa_levels_level_rank CHECK (level_rank > 0)
);

CREATE TABLE organism.life_stages (
    life_stage_id       INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    abbreviation        VARCHAR(1) UNIQUE NOT NULL,
    life_stage_name     VARCHAR(10) UNIQUE NOT NULL,
    is_visible          BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE organism.taxonomy (
    taxonomy_id         INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    taxonomy_name       VARCHAR(255) UNIQUE NOT NULL,
    level_id            INT NOT NULL,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_organism_taxonomy_level_id FOREIGN KEY (level_id) REFERENCES organism.levels(level_id)
);
CREATE INDEX fx_organism_taxonomy_level_id ON organism.taxonomy(level_id);

/*
 The Valid column is not currently used. But its there to invalidate
 a certain row, and then ignore it from all the subsequent processes.

 Currently delete the data if it is not valid. This was done infrequently
 as part of large QA efforts across big datasets.

 Experiment with using a date for invalidating a record. This can
 then reveal in a report whether the metrics predate a record
 getting eliminated.
 */
CREATE TABLE organism.organisms (
    sample_id           INT NOT NULL,
    taxa_id             INT NOT NULL,
    life_stage_id       INT NOT NULL,
    bug_size            REAL,

    split_count         REAL,
    big_rare_count      SMALLINT,
    invalidated_date    TIMESTAMPTZ,
    notes               TEXT,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT pk_organism_organisms PRIMARY KEY (sample_id, taxa_id, life_stage_id, bug_size),
    CONSTRAINT fk_organism_organism_taxonomy_id FOREIGN KEY (taxa_id) REFERENCES organism.taxonomy(taxonomy_id),
    CONSTRAINT fk_organism_organism_life_stage_id FOREIGN KEY (life_stage_id) REFERENCES organism.life_stages(life_stage_id)
);


/******************************************************************************************************************
 SAMPLE SCHEMA
 */

CREATE SCHEMA sample;
GRANT USAGE ON SCHEMA entity TO PUBLIC;

CREATE TABLE sample.sample_methods (
    sample_method_id    INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    sample_method_name  VARCHAR(20) UNIQUE NOT NULL,
    is_visible          BOOLEAN NOT NULL DEFAULT TRUE,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE sample.land_uses (
    land_use_id         INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    land_use_name       VARCHAR(50) UNIQUE NOT NULL,
    is_visible          BOOLEAN NOT NULL DEFAULT TRUE,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE sample.habitats (
    habitat_id          INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    habitat_name        VARCHAR(50) UNIQUE NOT NULL,
    ecosystem_id        INT NOT NULL,
    is_visible          BOOLEAN NOT NULL DEFAULT TRUE,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_habitats_ecosystem_id FOREIGN KEY (ecosystem_id) REFERENCES ecosystems(ecosystem_id)
);
CREATE INDEX ix_habitats_ecosystem_id ON sample.habitats(ecosystem_id);

CREATE TABLE sample.sample_types (
    sample_type_id      INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    sample_type_name    VARCHAR(20) UNIQUE NOT NULL,
    is_visible          BOOLEAN NOT NULL DEFAULT TRUE,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now()
);


CREATE TABLE sample.box_states (
    box_state_id       INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    box_state_name     VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE sample.projects (
    project_id          INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    project_name        VARCHAR(255),
    is_private          BOOLEAN DEFAULT TRUE,
    description         TEXT,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- TODO: table design incomplete
-- TODO: review columns copied from PilotDB.BugTacking
-- TODO: UsuTrack changed from FLOAT to SMALLINT
-- TODO: hook up billing_cust_id to customers? Confirm purpose
-- TODO: Default icost and tcost to zero?
CREATE TABLE sample.boxes (
    box_id              INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    customer_id         INT NOT NULL,
    creator_id          INT NOT NULL,
    box_status_id       INT NOT NULL,
    date_in             TIMESTAMPTZ,
    date_out            TIMESTAMPTZ,
    report_out          TIMESTAMPTZ,
    sort_time           FLOAT,
    id_time             FLOAT,
    overhead            FLOAT,
    total_time          FLOAT,
    porder              VARCHAR(255),
    icost               FLOAT,
    tcost               SMALLINT,
    notes               TEXT,
    project_id          INT,
    billing_customer_id INT,
    projected_date      TIMESTAMPTZ,
    completed_date      TIMESTAMPTZ,
    measurements        BOOLEAN NOT NULL DEFAULT FALSE,
    sorter_qa           BOOLEAN NOT NULL DEFAULT FALSE,
    taxa_qa             BOOLEAN NOT NULL DEFAULT FALSE,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_boxes_customer_id FOREIGN KEY (customer_id) REFERENCES entity.organizations(organization_id),
    CONSTRAINT fk_boxes_creator_id FOREIGN KEY (creator_id) REFERENCES entity.individuals(individual_id),
    CONSTRAINT fk_boxes_status_id FOREIGN KEY (box_status_id) REFERENCES sample.box_states(box_state_id),
    CONSTRAINT fk_boxes_project_id FOREIGN KEY (project_id) REFERENCES sample.projects(project_id)
);
CREATE INDEX fx_boxes_customer_id ON sample.boxes(customer_id);
CREATE INDEX fx_boxes_status_id ON sample.boxes(box_status_id);
CREATE INDEX fx_boxes_project_id ON sample.boxes(project_id);

-- TODO: Verify that it's OK to make qualitative NOT NULL and check what the default should be
-- TODO: verify that Count field is not needed?
-- TODO: verify that SorterChironomidae is needed?
-- TODO: what is the field PilotDB.BugSample.MainID?
-- TODO: what is the field PilotDB.BugSample.LabID?
-- TODO: what is the field PilotDB.BugSample.Replicates?
-- TODO: what is the field PilotDB.BugSample.Archive?
-- TODO: I have converted mesh FROM FLOAT to SMALLINT. OK? Values are 56, 120, 180, 425
CREATE TABLE sample.samples (
    sample_id           INT GENERATED BY DEFAULT AS IDENTITY,
    box_id              INT NOT NULL,
    site_id             INT,
    sample_date         DATE,
    sample_time         SMALLINT,
    type_id             INT NOT NULL,
    method_id           INT NOT NULL,
    habitat_id          INT NOT NULL,
    area                REAL,
    field_split         REAL,
    field_notes         TEXT,
    lab_split           REAL,
    elutriation         BOOLEAN,
    qualitative         BOOLEAN DEFAULT FALSE,
    lab_notes           TEXT,
    mesh                SMALLINT,
    sorter_count        SMALLINT,
    sorter_id           INT,
    sort_time           REAL NOT NULL DEFAULT 0,
    sort_start_date     TIMESTAMPTZ,
    sort_end_date       TIMESTAMPTZ,
    ider_id             INT,
    id_time             REAL NOT NULL DEFAULT 0,
    id_start_date       TIMESTAMPTZ,
    id_end_date         TIMESTAMPTZ,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    qa_sample_id        INT,
    lab_id              INT,

    CONSTRAINT pk_samples PRIMARY KEY (sample_id),
    CONSTRAINT fk_samples_box_id FOREIGN KEY (box_id) REFERENCES sample.boxes(box_id),
    CONSTRAINT fk_samples_site_id FOREIGN KEY (site_id) REFERENCES geo.sites(site_id),
    CONSTRAINT fk_samples_type_id FOREIGN KEY (type_id) REFERENCES sample.sample_types(sample_type_id),
    CONSTRAINT fk_samples_method_id FOREIGN KEY (method_id) REFERENCES sample.sample_methods(sample_method_id),
    CONSTRAINT fk_samples_habitat_id FOREIGN KEY (habitat_id) REFERENCES sample.habitats(habitat_id),
    CONSTRAINT fk_samples_sorter_id FOREIGN KEY (sorter_id) REFERENCES entity.individuals(individual_id),
    CONSTRAINT fk_samples_ider_id FOREIGN KEY (ider_id) REFERENCES entity.individuals(individual_id),
    CONSTRAINT fk_samples_lab_id FOREIGN KEY (lab_id) REFERENCES entity.organizations(organization_id),
    CONSTRAINT ck_samples_area CHECK (area >= 0),
    CONSTRAINT ck_samples_field_split CHECK (field_split >= 0),
    CONSTRAINT ck_samples_lab_split CHECK (lab_split >= 0),
    CONSTRAINT chk_samples_sorter_count CHECK (sorter_count >= 0),
    CONSTRAINT chk_samples_mesh CHECK (mesh > 0)
);
CREATE INDEX fx_samples_box_id ON sample.samples(box_id);
CREATE INDEX fx_samples_site_id ON sample.samples(site_id);
CREATE INDEX fx_samples_type_id ON sample.samples(type_id);
CREATE INDEX fx_samples_method_id ON sample.samples(method_id);
CREATE INDEX fx_samples_habitat_id ON sample.samples(habitat_id);
CREATE INDEX fx_samples_lab_id ON sample.samples(lab_id);

CREATE TYPE TOW_TYPES AS ENUM ('Vertical', 'Horizontal');


-- TODO: move fields from sample.samples to this table
CREATE TABLE sample.benthic (
    sample_id           INT NOT NULL PRIMARY KEY,
    notes               TEXT,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_sample_benthic_sample_id FOREIGN KEY (sample_id) REFERENCES sample.samples(sample_id)
);

CREATE TABLE sample.plantkton (
    sample_id           INT NOT NULL PRIMARY KEY,
    diameter            REAL,
    sub_sample_count    SMALLINT,
    tow_length          REAL,
    volume              REAL,
    all_quot            REAL,
    size_interval       REAL,
    tow_type            TOW_TYPES,
    notes               TEXT,
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_plankton_sample_id FOREIGN KEY (sample_id) REFERENCES sample.samples(sample_id),
    CONSTRAINT ck_plankton_diameter CHECK (diameter >= 0),
    CONSTRAINT ck_plankton_sub_sample_count CHECK (sub_sample_count >= 0),
    CONSTRAINT ck_plankton_tow_length CHECK (tow_length >= 0),
    CONSTRAINT ck_plankton_volume CHECK (volume >=0),
    CONSTRAINT ck_plankton_size_interval CHECK (size_interval >= 0)
);

-- TODO: confirm that velo means velocity
CREATE TABLE sample.drift (
    sample_id           INT NOT NULL PRIMARY KEY,
    diameter            FLOAT,
    net_time            FLOAT,
    stream_depth        FLOAT,
    net_depth           FLOAT,
    net_velo            FLOAT,
    notes               TEXT,
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT ck_bug_drift_diameter CHECK (diameter > 0),
    CONSTRAINT ck_bug_drift_net_time CHECK (net_time > 0),
    CONSTRAINT ck_bug_drift_stream_depth CHECK (stream_depth > 0),
    CONSTRAINT ck_bug_drift_net_depth CHECK (net_depth > 0),
    CONSTRAINT ck_bug_drift_net_velo CHECK (net_velo >= 0)
);


CREATE TABLE sample.organic_matter_types (
    organic_id     INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    organic_name   VARCHAR(20) UNIQUE NOT NULL
);

/*
 AFDM = Ash free dry mass
 The old bug o matter table used to have AFDM column. IT was a sum of several
 different kinds of mass.
 */
CREATE TABLE sample.organic_matter (
    sample_id           INT NOT NULL PRIMARY KEY,
    organic_id          INT NOT NULL,
    mass                REAL NOT NULL,
    notes               TEXT,

    CONSTRAINT fk_bug_o_matter FOREIGN KEY (sample_id) REFERENCES sample.samples(sample_id),
    CONSTRAINT fk_bug_o_matter_organic_id FOREIGN KEY (organic_id) REFERENCES sample.organic_matter_types(organic_id)
);
CREATE INDEX fx_bug_o_matter_organic_id ON sample.organic_matter(organic_id);

-- TODO: constraints on tpoints and spoints?
CREATE TABLE sample.vegetation (
    sample_id           INT NOT NULL PRIMARY KEY,
    taxonomy_id         INT NOT NULL,
    tpoints             REAL,
    spoints             REAL,
    notes               TEXT,
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_veg_samples_sample_id FOREIGN KEY (sample_id) REFERENCES sample.samples(sample_id),
    CONSTRAINT fk_veg_samples_species_id FOREIGN KEY (taxonomy_id) REFERENCES organism.taxonomy(taxonomy_id)
);
CREATE INDEX fx_veg_samples_taxa_id ON sample.vegetation(taxonomy_id);

-- TODO: What other fields are needed on this table?
CREATE TABLE sample.water (
    sample_id           INT NOT NULL PRIMARY KEY

);

-- TODO PilotDB.Stomachs.Code is NULL and the species column has species as text
CREATE TABLE sample.stomachs (
    sample_id           INT NOT NULL PRIMARY KEY,
    taxonomy_id         INT NOT NULL,
    fish_length         REAL,
    fish_mass           REAL,
    notes               TEXT,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_stomachs_sample_id FOREIGN KEY (sample_id) REFERENCES sample.samples(sample_id),
    CONSTRAINT fk_stomaches_taxonomy_id FOREIGN KEY (taxonomy_id) REFERENCES organism.taxonomy(taxonomy_id),
    CONSTRAINT ck_stomachs_fish_length CHECK (fish_length >= 0),
    CONSTRAINT ck_stomachs_fish_mass CHECK (fish_mass >= 0)
);
CREATE INDEX stomachs_taxa_id ON sample.stomachs(taxonomy_id);


CREATE TABLE sample.sort_qa (
    sample_id           INT NOT NULL PRIMARY KEY,
    sorter2_id          INT NOT NULL,
    sorted_date         TIMESTAMPTZ NOT NULL,
    bugs_resorted       SMALLINT NOT NULL,
    sorter_efficiency   REAL,
    elutriation         BOOLEAN NOT NULL,
    split               REAL,
    sort_time           REAL,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_sample_sort_qa_sorter2_id FOREIGN KEY (sorter2_id) REFERENCES entity.individuals(individual_id),
    CONSTRAINT ck_sample_sort_qa_bugs_resorted CHECK ( bugs_resorted >= 0),
    CONSTRAINT ck_sample_sort_qa_sorter_efficiency CHECK ((sorter_efficiency >= 0) AND (sorter_efficiency <= 100)),
    CONSTRAINT ck_sample_qaqc_qaqc_split CHECK ((split >=0) AND (split <= 100)),
    CONSTRAINT ck_sample_qaqc_sort_time CHECK ((sort_time>=0) AND (sort_time < 24))
);

-- TODO: maybe could be descriptive text instead? 'BEFORE RECONCILIATION' and 'AFTER RECONCILIATION'
CREATE TYPE QA_STAGES AS ENUM ('Before Reconciliation', 'After Reconciliation');

-- TODO: old table has OTUCode. What should this be now?
-- TODO: taxa_qa data type and reference?
-- TODO: should ider1 and ider2 be NOT NULL?
-- TODO: should ptd_class, bray_curtis_class and pde_class be boolean, enum or lookup?
-- TODO: constraints on the numerical fields
CREATE TABLE sample.taxa_qa (
    sample_id           INT NOT NULL PRIMARY KEY,
    taxa_qa             INT,
    taxa_qa_stage       QA_STAGES,
    start_date          TIMESTAMPTZ NOT NULL DEFAULT now(),
    ider1               INT NOT NULL,
    ider2               INT,
    sorter_count_diff   SMALLINT,
    taxa_count_diff     SMALLINT,
    code_count          SMALLINT,
    bray_curtis         REAL,
    bray_curtis_class   BOOLEAN,
    ptd                 REAL,
    ptd_class           BOOLEAN,
    pde                 REAL,
    pde_class           BOOLEAN,
    ptc1                REAL,
    ptc2                REAL,
    notes               TEXT,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT fk_sample_taxa_qa_ider1 FOREIGN KEY (ider1) REFERENCES entity.individuals(individual_id),
    CONSTRAINT fk_sample_taxa_qa_ider2 FOREIGN KEY (ider2) REFERENCES entity.individuals(individual_id)
);
CREATE INDEX fx_sample_taxa_qa_ider1 ON sample.taxa_qa(ider1);
CREATE INDEX fx_sample_taxa_qa_ider2 ON sample.taxa_qa(ider2);


CREATE TABLE sample_models (
    sample_id           INT NOT NULL,
    model_id            INT NOT NULL,
    model_result        DOUBLE PRECISION,
    created_date        TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_date        TIMESTAMPTZ NOT NULL DEFAULT now(),

    CONSTRAINT pk_sample_models PRIMARY KEY (sample_id, model_id),
    CONSTRAINT fk_sample_models_sample_id FOREIGN KEY (sample_id) REFERENCES sample.samples(sample_id),
    CONSTRAINT fk_samples_model_id FOREIGN KEY (model_id) REFERENCES models(model_id)
);
CREATE INDEX ix_sample_models_sample_id ON sample_models(sample_id);
CREATE INDEX ix_sample_models_model_id ON sample_models(model_id);

CREATE SCHEMA taxa;
GRANT USAGE ON SCHEMA taxa TO PUBLIC;

CREATE TABLE taxa.synonyms (
    synonym_id          INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    taxa_id             INT NOT NULL,
    synonym             VARCHAR(255)
);

/*
 ITIS
 Encyc of Life
 Wiki Species
 */
CREATE TABLE external_sources (
    source_id           INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    source_name         VARCHAR(255),
    abbreviation        VARCHAR(10)
);

/*
 TSN is the ITIS primary key

 ITIS calls synonyms valid or invalid for up to date or older name.
 */
CREATE TABLE external_ids (
--     external_id         INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,


    source_id           INT NOT NULL,
    taxa_id             INT NOT NULL,
    external_source_id  VARCHAR(255),
    scientific_name     VARCHAR(255)
)



-- TODO: What information does this table store?
-- TODO: can we drop bio_material and switch to using taxa_id
-- TODO: Why is the Code (taxa ID) is NULL for all records.
-- TODO: notes are all NULL.
-- TODO: review constraints
-- CREATE TABLE si_data (
--     sample_id           INT NOT NULL PRIMARY KEY,
--     bio_material        VARCHAR(255) NOT NULL,
--     taxa_id             INT,
--     fish_length         FLOAT,
--     fish_mass           FLOAT,
--     micro_g_n           FLOAT,
--     delta_air           FLOAT,
--     micro_g_c           FLOAT,
--     delta_pdb           FLOAT,
--     notes               TEXT,
--
--     CONSTRAINT fk_si_data_sample_id FOREIGN KEY (sample_id) REFERENCES sample.samples(sample_id),
--     CONSTRAINT fk_si_data_taxa_id FOREIGN KEY (taxa_id) REFERENCES organism.taxonomy(taxonomy_id),
--     CONSTRAINT ck_si_data_fish_length CHECK (fish_length >= 0),
--     CONSTRAINT ck_si_data_fish_mass CHECK (fish_mass >= 0),
--     CONSTRAINT ck_si_data_micro_g_n CHECK (micro_g_n >= 0),
--     CONSTRAINT ck_si_data_delta_air CHECK (delta_air >= 0),
--     CONSTRAINT ck_si_data_micro_g_c CHECK (micro_g_c >= 0),
--     CONSTRAINT ck_si_data_delta_pdb CHECK (delta_pdb >= 0)
-- );
-- CREATE INDEX fx_si_data_taxa_id ON si_data(taxa_id);

-- TODO: would be nice to have default for valid
-- TODO: Review choice of small int for big_rare_count
-- TODO: Review defaults and not null ofr split_count and big_rare_count
-- TODO: confirm RowIndex is not needed for this table (it's present in PilotDB.BugData)
-- CREATE TABLE bug_data (
--     sample_id           INT NOT NULL,
--     taxa_id             INT NOT NULL,
--     life_stage_id       INT NOT NULL,
--     bug_size            REAL,
--     split_count         float NOT NULL,
--     big_rare_count      SMALLINT,
--     notes               TEXT,
--     valid               BOOLEAN,
--
--     CONSTRAINT pk_bug_data PRIMARY KEY (sample_id, taxa_id, life_stage_id),
--     CONSTRAINT fk_bug_data_sample_id FOREIGN KEY (sample_id) REFERENCES sample.samples(sample_id),
--     CONSTRAINT fk_bug_data_taxa_id FOREIGN KEY (taxa_id) REFERENCES organism.taxonomy(taxonomy_id),
--     CONSTRAINT fk_bug_data_life_stage_id FOREIGN KEY (life_stage_id) REFERENCES organism.life_stages(life_stage_id),
--     CONSTRAINT ck_bug_data_bug_size CHECK (bug_size > 0),
--     CONSTRAINT ck_bug_data_split_count CHECK ((split_count >= 0) AND (split_count <= 100)),
--     CONSTRAINT ck_bug_data_big_rare_count CHECK (big_rare_count >= 0)
-- );



-- TODO: is this table needed? Looks legacy. No primary key in PilotDB.
-- PilotDB.BugVolumes.SampleID is decimal(18)
-- SampleID 143498 has four records in this table. They are all identical duplicates
-- Otherwise SampleID could be primary key
-- CREATE TABLE bug_volumes (
--     sample_id           INT NOT NULL PRIMARY KEY,
--     bug_volume          FLOAT,
--     plant_volume        FLOAT,
--     other_volume        FLOAT,
--     notes               TEXT,
--
--     CONSTRAINT fk_bug_volumes_sample_id FOREIGN KEY (sample_id) REFERENCES sample.samples(sample_id),
--     CONSTRAINT ck_bug_volumes_bug_volume CHECK (bug_volume >= 0),
--     CONSTRAINT ck_bug_volumes_plant_volume CHECK (plant_volume >= 0),
--     CONSTRAINT ck_bug_volumes_other_volume CHECK (other_volume >= 0)
-- );

