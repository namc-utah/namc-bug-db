import * as cdk from '@aws-cdk/core'
import * as cognito from '@aws-cdk/aws-cognito'
// import * as s3 from '@aws-cdk/aws-s3'
// import { NodejsFunction } from '@aws-cdk/aws-lambda-nodejs'
import { globalTags, stackProps } from '../config'
import { addTagsToResource } from './tags'

export interface CognitoProps {
    thing: string
}

class Cognito extends cdk.Construct {
    userPool: cognito.UserPool
    client: cognito.UserPoolClient

    constructor(scope: cdk.Construct, id: string, props: CognitoProps) {
        super(scope, id)

        this.userPool = new cognito.UserPool(this, `CognitoUserPool${stackProps.stage}`, {
            userPoolName: `${stackProps.stackPrefix}UserPool`,
            signInAliases: {
                email: true,
                username: false
            },
            signInCaseSensitive: false,
            selfSignUpEnabled: true
        })
        addTagsToResource(this.userPool, globalTags)

        // API Urls
        // TODO: Need to add the UI when we get there.

        // Client to connect to
        this.userPool.addDomain(`UserPoolDomain_${stackProps.stage}`, {
            cognitoDomain: {
                domainPrefix: `namc-${stackProps.stage}`
            }
        })

        this.client = new cognito.UserPoolClient(this, `CognitoUserPoolClient_${stackProps.stage}`, {
            userPool: this.userPool,
            generateSecret: false,
            userPoolClientName: `${stackProps.stackPrefix}UserPoolClient`,
            oAuth: {
                // TODO: THIS IS FOR DEV ONLY, OBVIOUSLY
                callbackUrls: ['http://localhost:/3000/namc/'],
                logoutUrls: ['http://localhost:/3000/namc/'],
                scopes: [cognito.OAuthScope.EMAIL, cognito.OAuthScope.OPENID, cognito.OAuthScope.PROFILE],
                flows: {
                    authorizationCodeGrant: true,
                    implicitCodeGrant: true,
                    clientCredentials: false
                }
            },
            authFlows: {
                adminUserPassword: true,
                userPassword: false,
                userSrp: true,
                custom: true
            }
        })
    }
}

export default Cognito