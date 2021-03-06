export * from './types';
export * as util from './util';
export declare const graphql: {
    typeDefs: import("graphql").DocumentNode;
    queryLimits: {
        samples: number;
        sites: number;
        boxes: number;
        projects: number;
        taxonomy: number;
        predictors: number;
        models: number;
        sitePredictorValues: number;
        modelPredictors: number;
        translations: number;
        metrics: number;
    };
};
