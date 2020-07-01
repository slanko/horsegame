using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class horseBehaviour : MonoBehaviour
{
    NavMeshAgent nav;
    Vector3 navPos;
    public float moveWaitTimeMin, moveWaitTimeMax, moveDistanceMin, moveDistanceMax;
    // Start is called before the first frame update
    void Start()
    {
        nav = GetComponent<NavMeshAgent>();
        changePosition();
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void changePosition()
    {
        Invoke("changePosition", Random.Range(moveWaitTimeMin, moveWaitTimeMax));
        navPos = Random.insideUnitSphere * Random.Range(moveDistanceMin, moveDistanceMax) + transform.position;
        nav.SetDestination(navPos);
    }
}
