class EggService
  @eggs = [
    {
      "_id": "522103164f08c30300000011",
      "bio": "\"All sorrows are less with bread.\" This quote from Miguel de Cervantes perfectly captures the importance of both great literature and delicious food in my life. Therefore, it's no surprise that I immediately found intrinsic beauty in the simplicity of a process that supplies people with nourishing, local food. Unfortunately, the benefits of local food have been restricted to those who have access to these markets and have the financial means to enter them. It's my dream to begin bridging this gap through a combination of equitable access, awareness and availability across all communities.",
      "createdAt": "2013-08-30T20:39:50.252Z",
      "foodshed": "sfbay",
      "photo": {
        "baseUrl": "https://www.filepicker.io/api/file/qKlgDeAxQWm7bPnGkG4d",
        "key": "user_profile_photo/5K8LE4VcQlWR1g0B7iR6_jillian.jpg"
      },
      "team": "Foodhub",
      "updatedAt": "2013-09-04T18:57:58.169Z",
      "user": {
        "_id": "51c21e7925b7470200000358",
        "email": "jillian@goodeggs.com",
        "firstName": "Jillian",
        "lastName": "Becerra",
      }
    },
    {
      "_id": "522103164f08c30300000012",
      "bio": "Some of my fondest memories are of going to my grandmother's farmhouse in Maryland, sitting around a big table sharing fresh corn on the cob with all my aunts, uncles, and cousins. 15 years later found me in rural Argentina, actually growing corn and tons of other vegetables with indigenous communities struggling daily to get enough food. I am passionate about creating a world where everyone can enjoy a family meal like the ones I had, without worrying about when the next one might come. I think the only real way to get there is through creating local, sustainable, and responsible solutions, which is why I love working at Good Eggs!",
      "createdAt": "2013-08-30T20:39:50.293Z",
      "foodshed": "sfbay",
      "photo": {
        "baseUrl": "https://www.filepicker.io/api/file/742ToQCRVODofTZpWAgc",
        "key": "user_profile_photo/5JDkeT1S2ao5BYIfApQD_zach.jpg"
      },
      "team": "Foodhub",
      "updatedAt": "2013-09-09T16:11:48.538Z",
      "user": {
        "_id": "51b9ea011b24c40200000090",
        "email": "zach@goodeggs.com",
        "firstName": "Zachary",
        "lastName": "Benton",
      }
    }
  ]

  @transform: (egg) ->
    email: egg.user.email
    name: egg.user.firstName
    photoUrl: "https://goodeggs2.imgix.net/#{egg.photo.key}?w=500&h=500&q=&fit=crop&crop=faces"

  @fetch: (done) ->
    setTimeout =>
      done null, @eggs.map @transform

module.exports = EggService
