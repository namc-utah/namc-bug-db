"use strict";
var __makeTemplateObject = (this && this.__makeTemplateObject) || function (cooked, raw) {
    if (Object.defineProperty) { Object.defineProperty(cooked, "raw", { value: raw }); } else { cooked.raw = raw; }
    return cooked;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
var graphql_tag_1 = __importDefault(require("graphql-tag"));
var typeDefs = graphql_tag_1.default(templateObject_1 || (templateObject_1 = __makeTemplateObject(["\n    schema {\n        query: Query\n        # mutation: Mutation\n    }\n\n    type Query {\n        # Get a project and associated metadata\n        auth: AuthParams\n\n        samples(limit: Int, nextToken: Int): PaginatedSample\n        boxStates(limit: Int, nextToken: Int): [BoxState]\n        sites(limit: Int, offset: Int): [Site]\n        siteInfo(siteId: Int!): SiteInfo\n        # individuals(limit: Int, nextToken: Int): [Individual]\n        boxes(limit: Int, offset: Int): [Box]\n    }\n\n    # this schema allows the following mutation:\n    # type Mutation {\n\n    # }\n\n    type AuthParams {\n        loggedIn: Boolean\n        userPool: String\n        clientId: String\n        region: String\n        domain: String\n    }\n\n    type PaginatedSample {\n        records: [Sample]\n        nextToken: Int\n    }\n\n    type Sample {\n        sampleId: Int\n        boxId: Int\n        customerId: Int\n        customerName: String\n        siteId: Int\n        siteName: String\n        sampleDate: String\n        sampleTime: String\n        typeId: Int\n        typeName: String\n        methodId: Int\n        methodName: String\n        habitatId: Int\n        habitatName: String\n        area: Float\n        fieldSplit: Float\n        labSplit: Float\n        jarCount: Int\n        qualitative: String\n        mesh: Int\n        createdDate: String\n        updatedDate: String\n        qaSampleId: Int\n    }\n\n    type BoxState {\n        boxStateId: Int\n    }\n\n    type Site {\n        siteId: Int\n        siteName: String\n        systemName: String\n        ecosystemName: String\n        longitude: Float\n        latitude: Float\n        state: String\n        waterbodyType: String\n        waterbodyCode: String\n        waterbodyName: String\n        createdDate: String\n        updatedDate: String\n        hasCatchment: Boolean\n    }\n\n    type SiteInfo {\n        siteId: Int\n        siteName: String\n        system: String\n        ecosystem: String\n        location: String\n        stX: Float\n        stY: Float\n        abbreviation: String\n        waterbodyTypeName: String\n        waterbodyCode: String\n        waterbodyName: String\n        createdDate: String\n        updatedDate: String\n        catchment: String\n        sampleCount: Int\n    }\n\n    type Individual {\n        entityId: Int\n        firstName: String\n        lastName: String\n        initials: String\n        affilitationId: Int\n        affiliation: String\n        email: String\n        title: String\n        address1: String\n        address2: String\n        city: String\n        stateName: String\n        countryName: String\n        zipCode: String\n        phone: String\n        fax: String\n    }\n\n    type Box {\n        boxId: Int\n        customerName: String\n        samples: Int\n        SubmitterName: String\n        boxStateName: String\n        boxReceivedDate: String\n        processingCompleteDate: String\n        projectedCompleteDate: String\n    }\n"], ["\n    schema {\n        query: Query\n        # mutation: Mutation\n    }\n\n    type Query {\n        # Get a project and associated metadata\n        auth: AuthParams\n\n        samples(limit: Int, nextToken: Int): PaginatedSample\n        boxStates(limit: Int, nextToken: Int): [BoxState]\n        sites(limit: Int, offset: Int): [Site]\n        siteInfo(siteId: Int!): SiteInfo\n        # individuals(limit: Int, nextToken: Int): [Individual]\n        boxes(limit: Int, offset: Int): [Box]\n    }\n\n    # this schema allows the following mutation:\n    # type Mutation {\n\n    # }\n\n    type AuthParams {\n        loggedIn: Boolean\n        userPool: String\n        clientId: String\n        region: String\n        domain: String\n    }\n\n    type PaginatedSample {\n        records: [Sample]\n        nextToken: Int\n    }\n\n    type Sample {\n        sampleId: Int\n        boxId: Int\n        customerId: Int\n        customerName: String\n        siteId: Int\n        siteName: String\n        sampleDate: String\n        sampleTime: String\n        typeId: Int\n        typeName: String\n        methodId: Int\n        methodName: String\n        habitatId: Int\n        habitatName: String\n        area: Float\n        fieldSplit: Float\n        labSplit: Float\n        jarCount: Int\n        qualitative: String\n        mesh: Int\n        createdDate: String\n        updatedDate: String\n        qaSampleId: Int\n    }\n\n    type BoxState {\n        boxStateId: Int\n    }\n\n    type Site {\n        siteId: Int\n        siteName: String\n        systemName: String\n        ecosystemName: String\n        longitude: Float\n        latitude: Float\n        state: String\n        waterbodyType: String\n        waterbodyCode: String\n        waterbodyName: String\n        createdDate: String\n        updatedDate: String\n        hasCatchment: Boolean\n    }\n\n    type SiteInfo {\n        siteId: Int\n        siteName: String\n        system: String\n        ecosystem: String\n        location: String\n        stX: Float\n        stY: Float\n        abbreviation: String\n        waterbodyTypeName: String\n        waterbodyCode: String\n        waterbodyName: String\n        createdDate: String\n        updatedDate: String\n        catchment: String\n        sampleCount: Int\n    }\n\n    type Individual {\n        entityId: Int\n        firstName: String\n        lastName: String\n        initials: String\n        affilitationId: Int\n        affiliation: String\n        email: String\n        title: String\n        address1: String\n        address2: String\n        city: String\n        stateName: String\n        countryName: String\n        zipCode: String\n        phone: String\n        fax: String\n    }\n\n    type Box {\n        boxId: Int\n        customerName: String\n        samples: Int\n        SubmitterName: String\n        boxStateName: String\n        boxReceivedDate: String\n        processingCompleteDate: String\n        projectedCompleteDate: String\n    }\n"])));
exports.default = typeDefs;
var templateObject_1;
//# sourceMappingURL=schema.graphql.js.map