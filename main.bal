// import ballerina/io;
import ballerina/http;

type OMDBSearchItem record {
    string Title;
    string Year;
    string Poster;
};
type OMDBSearchResult record {
    OMDBSearchItem[] Search;
};
type moviesAlbum record {|
    string Title;
    string Year;
    string Poster;
|};

service /pickamovie on new http:Listener(8000){
    resource function get movies(string movieName) returns moviesAlbum[]|error? {
        http:Client omdb =check new("https://www.omdbapi.com");
        OMDBSearchResult search = check omdb->get(searchURL(movieName));
        return from OMDBSearchItem i in search.Search
            select {Title:i.Title,Year:i.Year,Poster:i.Poster}
        ;
    }
}

function searchURL(string movieName) returns string{
    return "/?apikey=609ce6f4&s="+movieName;
}
