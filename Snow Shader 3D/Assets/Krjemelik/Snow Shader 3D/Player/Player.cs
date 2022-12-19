using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static UnityEngine.GraphicsBuffer;

public class Player : MonoBehaviour
{
    [SerializeField] private Transform _target;
    [SerializeField] private float _speed;

    private void Start()
    {
        _target.transform.position =
            new Vector3(_target.transform.position.x, transform.position.y, _target.transform.position.z);
    }

    void Update()
    {
        Move();
    }

    protected virtual void Move()
    {
        transform.position = Vector3.MoveTowards(
            transform.position,
            _target.transform.position,
            _speed * Time.deltaTime);
    }
}
