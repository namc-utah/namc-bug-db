"use strict";
var __makeTemplateObject = (this && this.__makeTemplateObject) || function (cooked, raw) {
    if (Object.defineProperty) { Object.defineProperty(cooked, "raw", { value: raw }); } else { cooked.raw = raw; }
    return cooked;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.queryLimits = void 0;
var graphql_tag_1 = __importDefault(require("graphql-tag"));
exports.queryLimits = {
    samples: 500,
    sampleOrganisms: 100,
    projectOrganisms: 100,
    boxStates: 500,
    sites: 500,
    boxes: 500,
    projects: 500,
    taxonomy: 500,
    predictors: 500,
    models: 500,
    sitePredictorValues: 500
};
var typeDefs = graphql_tag_1.default(templateObject_1 || (templateObject_1 = __makeTemplateObject(["\n    schema {\n        query: Query\n        # mutation: Mutation\n    }\n\n    type Query {\n        # Get a project and associated metadata\n        auth: AuthParams\n\n        siteInfo(siteId: Int!): SiteInfo\n\n        samples(limit: Int = ", ", offset: Int = 0): PaginatedSamples\n        sampleOrganisms(\n            limit: Int = ", "\n            offset: Int = 0\n            sampleId: Int\n            boxId: Int\n            siteId: Int\n            sampleYear: Int\n            typeId: Int\n        ): PaginatedSampleOrganisms\n\n        projectOrganisms(projectIds: [Int]!, limit: Int = ", ", offset: Int =0): PaginatedSampleOrganisms\n        boxStates(limit: Int = ", ", offset: Int = 0): PaginatedBoxStates\n        sites(limit: Int = ", ", offset: Int = 0): PaginatedSites\n        # individuals(limit: Int, offset: Int): [Individual]\n        boxes(limit: Int = ", ", offset: Int = 0): PaginatedBoxes\n        projects(limit: Int = ", ", offset: Int = 0): PaginatedProjects\n        taxonomy(limit: Int = ", ", offset: Int = 0): PaginatedTaxonomies\n        predictors(modelId: Int, limit: Int = ", ", offset: Int = 0): PaginatedPredictors\n        models(limit: Int = ", ", offset: Int = 0): PaginatedModels\n        sitePredictorValues(siteId: Int!, limit: Int = ", ", offset: Int = 0): PaginatedSitePredictorValues\n    }\n\n    # this schema allows the following mutation:\n    # type Mutation {\n\n    # }\n\n    type AuthParams {\n        loggedIn: Boolean\n        userPool: String\n        clientId: String\n        region: String\n        domain: String\n    }\n\n    type Sample {\n        sampleId: Int\n        boxId: Int\n        customerName: String\n        boxStateName: String\n        boxStateId: Int\n        submitterName: String\n        siteId: Int\n        siteName: String\n        siteLatitude: Float\n        siteLongitude: Float\n        siteState: String\n        sampleDate: String\n        sampleYear: Int\n        sampleLatitude: Float\n        sampleLongitude: Float\n        sampleType: String\n        sampleMethod: String\n        habitatName: String\n        area: Float\n        fieldSplit: Float\n        labSplit: Float\n        jarCount: Int\n        qualitative: Boolean\n        mesh: Float\n        createdDate: String\n        updatedDate: String\n        qaSampleId: Int\n        diameter: Float\n        subSampleCount: Float\n        towLength: Float\n        volume: Float\n        aliquot: Float\n        siteInterval: Float\n        towType: String\n        netArea: Float\n        netDuration: Float\n        streamDepth: Float\n        netDepth: Float\n        netVelocity: Float\n    }\n\n    type BoxState {\n        boxStateId: Int\n    }\n\n    type Site {\n        siteId: Int\n        siteName: String\n        system: String\n        ecosystem: String\n        longitude: Float\n        latitude: Float\n        usState: String\n        waterbodyType: String\n        waterbodyCode: String\n        waterbodyName: String\n        createdDate: String\n        updatedDate: String\n        hasCatchment: Boolean\n    }\n\n    type SiteInfo {\n        siteId: Int\n        siteName: String\n        system: String\n        ecosystem: String\n        location: String\n        longitude: Float\n        latitude: Float\n        usState: String\n        waterbodyTypeName: String\n        waterbodyCode: String\n        waterbodyName: String\n        createdDate: String\n        updatedDate: String\n        catchment: String\n        sampleCount: Int\n    }\n\n    #  type Individual {\n    #     entityId: Int\n    #     firstName: String\n    #     lastName: String\n    #     initials: String\n    #     affilitationId: Int\n    #     affiliation: String\n    #     email: String\n    #     title: String\n    #     address1: String\n    #     address2: String\n    #     city: String\n    #     stateName: String\n    #     countryName: String\n    #     zipCode: String\n    #     phone: String\n    #     fax: String\n    # }\n\n    type Box {\n        boxId: Int\n        customerName: String\n        samples: Int\n        SubmitterName: String\n        boxStateName: String\n        boxReceivedDate: String\n        processingCompleteDate: String\n        projectedCompleteDate: String\n    }\n\n    type SampleOrganism {\n        sampleId: Int\n        boxId: Int\n        customerId: Int\n        customerName: String\n        boxStateName: String\n        boxStateId: Int\n        submitterName: String\n        siteId: Int\n        siteName: String\n        siteLatitude: Float\n        siteLongitude: Float\n        siteState: String\n        sampleDate: String\n        sampleLatitude: Float\n        sampleLongitude: Float\n        sampleTime: String\n        typeId: Int\n        sampleType: String\n        methodId: Int\n        sampleMethod: String\n        habitatId: Int\n        habitatName: String\n        area: Float\n        fieldSplit: Float\n        labSplit: Float\n        jarCount: Float\n        qualitative: Boolean\n        mesh: Float\n        createdDate: String\n        updatedDate: String\n        qaSampleId: Int\n        diameter: Float\n        subSampleCount: Float\n        towLength: Float\n        volume: Float\n        aliquot: Float\n        sizeInterval: Float\n        towType: String\n        netArea: Float\n        netDuration: Float\n        streamDepth: Float\n        netDepth: Float\n        netVelocity: Float\n        taxonomyId: Int\n        lifeStage: String\n        bugSize: Float\n        splitCount: Float\n        bigRareCount: Float\n        phylum: String\n        class: String\n        subClass: String\n        order: String\n        family: String\n        genus: String\n        isPrivate: Boolean\n    }\n\n    type Project {\n        projectId: Int\n        projectName: String\n        projectType: String\n        isPrivate: Boolean\n        contact: String\n        autoUpdateSamples: Boolean\n        description: String\n        createdDate: String\n        updatedDate: String\n        samples: Int\n    }\n\n    type Taxonomy {\n        taxonomyId: Int\n        phylum: String\n        class: String\n        subclass: String\n        order: String\n        suborder: String\n        family: String\n        subfamily: String\n        tribe: String\n        genus: String\n        subgenus: String\n        species: String\n        subspecies: String\n    }\n\n    type Predictor {\n        predictorId: Int\n        predictorName: String\n        abbreviation: String\n        description: String\n        units: String\n        calculationScript: String\n        predictorTypeId: Int\n        predictorTypeName: String\n        isTemporal: Boolean\n        updatedDate: String\n        createdDate: String\n        modelCount: Int\n    }\n\n    type Model {\n        modelId: Int\n        modelName: String\n        abbreviation: String\n        isActive: Boolean\n        description: String\n        predictorCount: Int\n    }\n\n    type SitePredictorValue {\n        predictorId: Int\n        predictorName: String\n        abbreviation: String\n        description: String\n        predictorTypeName: String\n        metadata: String\n        createdDate: String\n        updatedDate: String\n        calculationScript: String\n    }\n\n    # Pagination Types\n    type PaginatedBoxStates {\n        records: [BoxState]\n        nextOffset: Int\n    }\n    type PaginatedModels {\n        records: [Model]\n        nextOffset: Int\n    }\n    type PaginatedSites {\n        records: [Site]\n        nextOffset: Int\n    }\n    type PaginatedSamples {\n        records: [Sample]\n        nextOffset: Int\n    }\n    type PaginatedSampleOrganisms {\n        records: [SampleOrganism]\n        nextOffset: Int\n    }\n    type PaginatedBoxes {\n        records: [Box]\n        nextOffset: Int\n    }\n    type PaginatedProjects {\n        records: [Project]\n        nextOffset: Int\n    }\n    type PaginatedTaxonomies {\n        records: [Taxonomy]\n        nextOffset: Int\n    }\n    type PaginatedPredictors {\n        records: [Predictor]\n        nextOffset: Int\n    }\n    type PaginatedSitePredictorValues {\n        records: [SitePredictorValue]\n        nextOffset: Int\n    }\n"], ["\n    schema {\n        query: Query\n        # mutation: Mutation\n    }\n\n    type Query {\n        # Get a project and associated metadata\n        auth: AuthParams\n\n        siteInfo(siteId: Int!): SiteInfo\n\n        samples(limit: Int = ", ", offset: Int = 0): PaginatedSamples\n        sampleOrganisms(\n            limit: Int = ", "\n            offset: Int = 0\n            sampleId: Int\n            boxId: Int\n            siteId: Int\n            sampleYear: Int\n            typeId: Int\n        ): PaginatedSampleOrganisms\n\n        projectOrganisms(projectIds: [Int]!, limit: Int = ", ", offset: Int =0): PaginatedSampleOrganisms\n        boxStates(limit: Int = ", ", offset: Int = 0): PaginatedBoxStates\n        sites(limit: Int = ", ", offset: Int = 0): PaginatedSites\n        # individuals(limit: Int, offset: Int): [Individual]\n        boxes(limit: Int = ", ", offset: Int = 0): PaginatedBoxes\n        projects(limit: Int = ", ", offset: Int = 0): PaginatedProjects\n        taxonomy(limit: Int = ", ", offset: Int = 0): PaginatedTaxonomies\n        predictors(modelId: Int, limit: Int = ", ", offset: Int = 0): PaginatedPredictors\n        models(limit: Int = ", ", offset: Int = 0): PaginatedModels\n        sitePredictorValues(siteId: Int!, limit: Int = ", ", offset: Int = 0): PaginatedSitePredictorValues\n    }\n\n    # this schema allows the following mutation:\n    # type Mutation {\n\n    # }\n\n    type AuthParams {\n        loggedIn: Boolean\n        userPool: String\n        clientId: String\n        region: String\n        domain: String\n    }\n\n    type Sample {\n        sampleId: Int\n        boxId: Int\n        customerName: String\n        boxStateName: String\n        boxStateId: Int\n        submitterName: String\n        siteId: Int\n        siteName: String\n        siteLatitude: Float\n        siteLongitude: Float\n        siteState: String\n        sampleDate: String\n        sampleYear: Int\n        sampleLatitude: Float\n        sampleLongitude: Float\n        sampleType: String\n        sampleMethod: String\n        habitatName: String\n        area: Float\n        fieldSplit: Float\n        labSplit: Float\n        jarCount: Int\n        qualitative: Boolean\n        mesh: Float\n        createdDate: String\n        updatedDate: String\n        qaSampleId: Int\n        diameter: Float\n        subSampleCount: Float\n        towLength: Float\n        volume: Float\n        aliquot: Float\n        siteInterval: Float\n        towType: String\n        netArea: Float\n        netDuration: Float\n        streamDepth: Float\n        netDepth: Float\n        netVelocity: Float\n    }\n\n    type BoxState {\n        boxStateId: Int\n    }\n\n    type Site {\n        siteId: Int\n        siteName: String\n        system: String\n        ecosystem: String\n        longitude: Float\n        latitude: Float\n        usState: String\n        waterbodyType: String\n        waterbodyCode: String\n        waterbodyName: String\n        createdDate: String\n        updatedDate: String\n        hasCatchment: Boolean\n    }\n\n    type SiteInfo {\n        siteId: Int\n        siteName: String\n        system: String\n        ecosystem: String\n        location: String\n        longitude: Float\n        latitude: Float\n        usState: String\n        waterbodyTypeName: String\n        waterbodyCode: String\n        waterbodyName: String\n        createdDate: String\n        updatedDate: String\n        catchment: String\n        sampleCount: Int\n    }\n\n    #  type Individual {\n    #     entityId: Int\n    #     firstName: String\n    #     lastName: String\n    #     initials: String\n    #     affilitationId: Int\n    #     affiliation: String\n    #     email: String\n    #     title: String\n    #     address1: String\n    #     address2: String\n    #     city: String\n    #     stateName: String\n    #     countryName: String\n    #     zipCode: String\n    #     phone: String\n    #     fax: String\n    # }\n\n    type Box {\n        boxId: Int\n        customerName: String\n        samples: Int\n        SubmitterName: String\n        boxStateName: String\n        boxReceivedDate: String\n        processingCompleteDate: String\n        projectedCompleteDate: String\n    }\n\n    type SampleOrganism {\n        sampleId: Int\n        boxId: Int\n        customerId: Int\n        customerName: String\n        boxStateName: String\n        boxStateId: Int\n        submitterName: String\n        siteId: Int\n        siteName: String\n        siteLatitude: Float\n        siteLongitude: Float\n        siteState: String\n        sampleDate: String\n        sampleLatitude: Float\n        sampleLongitude: Float\n        sampleTime: String\n        typeId: Int\n        sampleType: String\n        methodId: Int\n        sampleMethod: String\n        habitatId: Int\n        habitatName: String\n        area: Float\n        fieldSplit: Float\n        labSplit: Float\n        jarCount: Float\n        qualitative: Boolean\n        mesh: Float\n        createdDate: String\n        updatedDate: String\n        qaSampleId: Int\n        diameter: Float\n        subSampleCount: Float\n        towLength: Float\n        volume: Float\n        aliquot: Float\n        sizeInterval: Float\n        towType: String\n        netArea: Float\n        netDuration: Float\n        streamDepth: Float\n        netDepth: Float\n        netVelocity: Float\n        taxonomyId: Int\n        lifeStage: String\n        bugSize: Float\n        splitCount: Float\n        bigRareCount: Float\n        phylum: String\n        class: String\n        subClass: String\n        order: String\n        family: String\n        genus: String\n        isPrivate: Boolean\n    }\n\n    type Project {\n        projectId: Int\n        projectName: String\n        projectType: String\n        isPrivate: Boolean\n        contact: String\n        autoUpdateSamples: Boolean\n        description: String\n        createdDate: String\n        updatedDate: String\n        samples: Int\n    }\n\n    type Taxonomy {\n        taxonomyId: Int\n        phylum: String\n        class: String\n        subclass: String\n        order: String\n        suborder: String\n        family: String\n        subfamily: String\n        tribe: String\n        genus: String\n        subgenus: String\n        species: String\n        subspecies: String\n    }\n\n    type Predictor {\n        predictorId: Int\n        predictorName: String\n        abbreviation: String\n        description: String\n        units: String\n        calculationScript: String\n        predictorTypeId: Int\n        predictorTypeName: String\n        isTemporal: Boolean\n        updatedDate: String\n        createdDate: String\n        modelCount: Int\n    }\n\n    type Model {\n        modelId: Int\n        modelName: String\n        abbreviation: String\n        isActive: Boolean\n        description: String\n        predictorCount: Int\n    }\n\n    type SitePredictorValue {\n        predictorId: Int\n        predictorName: String\n        abbreviation: String\n        description: String\n        predictorTypeName: String\n        metadata: String\n        createdDate: String\n        updatedDate: String\n        calculationScript: String\n    }\n\n    # Pagination Types\n    type PaginatedBoxStates {\n        records: [BoxState]\n        nextOffset: Int\n    }\n    type PaginatedModels {\n        records: [Model]\n        nextOffset: Int\n    }\n    type PaginatedSites {\n        records: [Site]\n        nextOffset: Int\n    }\n    type PaginatedSamples {\n        records: [Sample]\n        nextOffset: Int\n    }\n    type PaginatedSampleOrganisms {\n        records: [SampleOrganism]\n        nextOffset: Int\n    }\n    type PaginatedBoxes {\n        records: [Box]\n        nextOffset: Int\n    }\n    type PaginatedProjects {\n        records: [Project]\n        nextOffset: Int\n    }\n    type PaginatedTaxonomies {\n        records: [Taxonomy]\n        nextOffset: Int\n    }\n    type PaginatedPredictors {\n        records: [Predictor]\n        nextOffset: Int\n    }\n    type PaginatedSitePredictorValues {\n        records: [SitePredictorValue]\n        nextOffset: Int\n    }\n"])), exports.queryLimits.samples, exports.queryLimits.sampleOrganisms, exports.queryLimits.projectOrganisms, exports.queryLimits.boxStates, exports.queryLimits.sites, exports.queryLimits.boxes, exports.queryLimits.projects, exports.queryLimits.taxonomy, exports.queryLimits.predictors, exports.queryLimits.models, exports.queryLimits.sitePredictorValues);
exports.default = typeDefs;
var templateObject_1;
//# sourceMappingURL=schema.graphql.js.map