export default {
    name: 'fairEvent',
    title: 'Fair Event',
    type: 'document',
    fields: [
        {
            name: 'title',
            title: 'title',
            type: 'string',
        },
        {
            name: 'orgId',
            title: 'orgId',
            type: 'string',
        },
        {
            name: 'startsAt',
            title: 'startsAt',
            type: 'datetime',
        },
        {
            name: 'venue',
            title: 'venue',
            type: 'string',
        },
        {
            name: 'description',
            title: 'description',
            type: 'text',
        },
        {
            name: 'cancelled',
            title: 'cancelled',
            type: 'boolean',
        },
    ],
}